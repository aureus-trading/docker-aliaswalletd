#!groovy

pipeline {
    agent {
        label "docker"
    }
    options {
        timestamps()
        timeout(time: 3, unit: 'HOURS')
        buildDiscarder(logRotator(numToKeepStr: '30', artifactNumToKeepStr: '5'))
    }
    environment {
        // In case another branch beside master or develop should be deployed, enter it here
        BRANCH_TO_DEPLOY = 'xyz'
        GITHUB_TOKEN = credentials('cdc81429-53c7-4521-81e9-83a7992bca76')
        DISCORD_WEBHOOK = credentials('991ce248-5da9-4068-9aea-8a6c2c388a19')
    }
    parameters {
        string(name: 'SPECTRECOIN_RELEASE', defaultValue: '2.2.0', description: 'Which release of Spectrecoin should be used?')
    }
    stages {
        stage('Notification') {
            steps {
                discordSend(
                        description: "**Started build of branch $BRANCH_NAME**\n",
                        footer: 'Jenkins - the builder',
                        image: '',
                        link: "$env.BUILD_URL",
                        successful: true,
                        thumbnail: 'https://wiki.jenkins-ci.org/download/attachments/2916393/headshot.png',
                        title: "$env.JOB_NAME",
                        webhookURL: "${DISCORD_WEBHOOK}"
                )
            }
        }
        stage('Pull base image') {
            steps {
                script {
                    sh "docker pull ubuntu:18.04"
                }
            }
        }
        stage('Just build Spectrecoin image') {
            when {
                not {
                    anyOf { branch 'develop'; branch 'master'; branch "${BRANCH_TO_DEPLOY}" }
                }
            }
            steps {
                script {
                    docker.build(
                            "spectreproject/docker-spectrecoind",
                            "--rm --build-arg DOWNLOAD_URL=https://github.com/spectrecoin/spectre/releases/download/latest/Spectrecoin-latest-Ubuntu.tgz ."
                    )
                }
            }
        }
        stage('Build and upload Spectrecoin image (develop)') {
            when {
                anyOf { branch 'develop'; branch "${BRANCH_TO_DEPLOY}" }
            }
            steps {
                script {
                    def spectre_image = docker.build(
                            "spectreproject/docker-spectrecoind",
                            "--rm --build-arg DOWNLOAD_URL=https://github.com/spectrecoin/spectre/releases/download/latest/Spectrecoin-latest-Ubuntu.tgz ."
                    )
                    docker.withRegistry('https://registry.hub.docker.com', '051efa8c-aebd-40f7-9cfd-0053c413266e') {
                        spectre_image.push("latest")
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
                    def spectre_image = docker.build(
                            "spectreproject/docker-spectrecoind",
                            "--rm --build-arg DOWNLOAD_URL=https://github.com/spectrecoin/spectre/releases/download/${SPECTRECOIN_RELEASE}/Spectrecoin-${SPECTRECOIN_RELEASE}-Ubuntu.tgz ."
                    )
                    docker.withRegistry('https://registry.hub.docker.com', '051efa8c-aebd-40f7-9cfd-0053c413266e') {
                        spectre_image.push("${SPECTRECOIN_RELEASE}")
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
                        description: "**Build:**  #$env.BUILD_NUMBER\n**Status:**  Success\n",
                        footer: 'Jenkins - the builder',
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
                    description: "**Build:**  #$env.BUILD_NUMBER\n**Status:**  Unstable\n",
                    footer: 'Jenkins - the builder',
                    image: '',
                    link: "$env.BUILD_URL",
                    successful: true,
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
                    description: "**Build:**  #$env.BUILD_NUMBER\n**Status:**  Failed\n",
                    footer: 'Jenkins - the builder',
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
