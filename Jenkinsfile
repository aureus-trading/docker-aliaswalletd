#!groovy

pipeline {
    agent {
        label "docker"
    }
    options {
        timestamps()
        timeout(time: 3, unit: 'HOURS')
        buildDiscarder(logRotator(numToKeepStr: '30', artifactNumToKeepStr: '5'))
        disableConcurrentBuilds()
    }
    environment {
        // In case another branch beside master or develop should be deployed, enter it here
        BRANCH_TO_DEPLOY = 'xyz'
        GITHUB_TOKEN = credentials('cdc81429-53c7-4521-81e9-83a7992bca76')
        DISCORD_WEBHOOK = credentials('991ce248-5da9-4068-9aea-8a6c2c388a19')
    }
    parameters {
        string(name: 'SPECTRECOIN_RELEASE', defaultValue: '4.1.0', description: 'Which release of Spectrecoin should be used?')
        string(name: 'GIT_COMMIT_SHORT', defaultValue: '', description: 'Git short commit, which is part of the name of required archive.')
    }
    stages {
        stage('Notification') {
            steps {
                // Using result state 'ABORTED' to mark the message on discord with a white border.
                // Makes it easier to distinguish job-start from job-finished
                discordSend(
                        description: "Started build #$env.BUILD_NUMBER",
                        image: '',
                        link: "$env.BUILD_URL",
                        successful: true,
                        result: "ABORTED",
                        thumbnail: 'https://wiki.jenkins-ci.org/download/attachments/2916393/headshot.png',
                        title: "$env.JOB_NAME",
                        webhookURL: "${DISCORD_WEBHOOK}"
                )
            }
        }
        stage('Build Spectrecoin image') {
            when {
                not {
                    branch 'master'
                }
            }
            steps {
                script {
                    withDockerRegistry(credentialsId: '051efa8c-aebd-40f7-9cfd-0053c413266e') {
                        sh "docker build \\\n" +
                                "--rm \\\n" +
                                "--build-arg DOWNLOAD_URL=https://github.com/aliascash/alias-wallet/releases/download/${ALIAS_RELEASE}/Alias-${ALIAS_RELEASE}-${GIT_COMMIT_SHORT}-Ubuntu-18-04.tgz \\\n" +
                                "-t aliascash/docker-aliaswalletd:${ALIAS_RELEASE} \\\n" +
                                "."
                    }
                }
            }
        }
        stage('Upload Spectrecoin image (develop)') {
            when {
                anyOf { branch 'develop'; branch "${BRANCH_TO_DEPLOY}" }
            }
            steps {
                script {
                    withDockerRegistry(credentialsId: '051efa8c-aebd-40f7-9cfd-0053c413266e') {
                        sh "docker push spectreproject/docker-spectrecoind:${SPECTRECOIN_RELEASE}"
                    }
                }
            }
        }
        stage('Build and upload Spectrecoin image (master)') {
            when {
                branch 'master'
            }
            steps {
                script {
                    withDockerRegistry(credentialsId: '051efa8c-aebd-40f7-9cfd-0053c413266e') {
                        sh "docker build \\\n" +
                                "--rm \\\n" +
                                "--build-arg DOWNLOAD_URL=https://github.com/aliascash/alias-wallet/releases/download/${ALIAS_RELEASE}/Alias-${ALIAS_RELEASE}-${GIT_COMMIT_SHORT}-Ubuntu-18-04.tgz \\\n" +
                                "-t aliascash/docker-aliaswalletd:${ALIAS_RELEASE} \\\n" +
                                "."
                        sh "docker push spectreproject/docker-spectrecoind:${SPECTRECOIN_RELEASE}"
                    }
                }
            }
        }
    }
    post {
        always {
            sh "docker system prune --all --force"
        }
        success {
            script {
                if (!hudson.model.Result.SUCCESS.equals(currentBuild.getPreviousBuild()?.getResult())) {
                    emailext(
                            subject: "GREEN: '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                            body: '${JELLY_SCRIPT,template="html"}',
                            recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']],
//                            to: "to@be.defined",
//                            replyTo: "to@be.defined"
                    )
                }
                discordSend(
                        description: "Build #$env.BUILD_NUMBER finished successfully",
                        image: '',
                        link: "$env.BUILD_URL",
                        successful: true,
                        thumbnail: 'https://wiki.jenkins-ci.org/download/attachments/2916393/headshot.png',
                        title: "$env.JOB_NAME",
                        webhookURL: "${DISCORD_WEBHOOK}"
                )
            }
        }
        unstable {
            emailext(
                    subject: "YELLOW: '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                    body: '${JELLY_SCRIPT,template="html"}',
                    recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']],
//                    to: "to@be.defined",
//                    replyTo: "to@be.defined"
            )
            discordSend(
                    description: "Build #$env.BUILD_NUMBER finished unstable",
                    image: '',
                    link: "$env.BUILD_URL",
                    successful: true,
                    result: "UNSTABLE",
                    thumbnail: 'https://wiki.jenkins-ci.org/download/attachments/2916393/headshot.png',
                    title: "$env.JOB_NAME",
                    webhookURL: "${DISCORD_WEBHOOK}"
            )
        }
        failure {
            emailext(
                    subject: "RED: '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                    body: '${JELLY_SCRIPT,template="html"}',
                    recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']],
//                    to: "to@be.defined",
//                    replyTo: "to@be.defined"
            )
            discordSend(
                    description: "Build #$env.BUILD_NUMBER failed!",
                    image: '',
                    link: "$env.BUILD_URL",
                    successful: false,
                    thumbnail: 'https://wiki.jenkins-ci.org/download/attachments/2916393/headshot.png',
                    title: "$env.JOB_NAME",
                    webhookURL: "${DISCORD_WEBHOOK}"
            )
        }
    }
}
