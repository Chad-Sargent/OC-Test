node("master") {
    try {
        retry(1) {
            //set properties for the job's configuration
            properties([buildDiscarder(logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '', numToKeepStr: '30')), [$class: 'RebuildSettings', autoRebuild: false, rebuildDisabled: false]])
            //Parse job name into environment variables
            parseJob.jobSplit("${env.JOB_BASE_NAME}")
            helperFunctions.setDisplayNameAuto(this)
            
            stage("checkout") {
                checkOutFrom(parseJob.type,"",parseJob.os,parseJob.stage,env.DEV_HOUR)
            }
            stage("set environment") {
                return sh(returnStderr: true, script: '''
          touch vars.properties
          chmod -R +x build/pipeline-scripts/linux
          ${WORKSPACE}/build/pipeline-scripts/linux/set_environment.sh
        ''')
            }
            stage("copy Dependencies") {
                return sh(returnStderr: true, script: '''
          ${WORKSPACE}/build/pipeline-scripts/linux/copy_dependencies.sh
        ''')
            }
            stage("premake") {
                return sh(returnStderr: true, script: '''#!/bin/bash
          ${WORKSPACE}/build/pipeline-scripts/linux/run_premake.sh
        ''')
            }
            //Read properties file from current job workspace into an array
            def props=readProperties  file: 'vars.properties'
            def architectures="${props.MAKE_CONFIGS}".replaceAll("[()]", "").trim().split(" ")
            for (i = 0; i < architectures.size(); i++) {
                def tmp=architectures[i]
                stage("make ${tmp}") {
                    return sh(returnStderr: true, script: "${WORKSPACE}/build/pipeline-scripts/linux/run_makeall.sh ${tmp}")
                }
                stage("archive"){
                    return sh(returnStderr: true, script: "${WORKSPACE}/build/pipeline-scripts/linux/archive.sh ${tmp}")
                }
            }
        }
    } catch (err) {
        currentBuild.result="FAILURE"
        throw err
    } finally {
        //Parse the logs based on pre-defined rules
        step([$class: 'LogParserPublisher', parsingRulesPath: '/var/lib/jenkins/parse/linux/jenkins_parse.txt', failBuildOnError: true])
        stage("post-build") {
            if(currentBuild.result != "FAILURE") {
                // postBuildTrigger()
                //check if this is not a new job
                if(currentBuild.previousBuild) {
                    if(currentBuild.previousBuild.result == "FAILURE" && currentBuild.result != "ABORTED") {
                        helperFunctions.notify("backtonormal")
                    }
                }
            } else {
                if(currentBuild.previousBuild) {
                    if(currentBuild.previousBuild.result != "FAILURE") {
                        helperFunctions.notify("failed")
                    }
                }
            }
        }
        //Clean workspace after the job has completed
        cleanWs cleanWhenFailure: true, deleteDirs: true, disableDeferredWipeout: true
    }
}
