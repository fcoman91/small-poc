#!/usr/bin/env groovy

pipeline {
    agent any

    options {
        timestamps()
    }

    stages {
        stage("Download GitHub repository") {
            steps {
                git url: 'https://github.com/fcoman91/small-poc.git'
            }
        }
        stage("Run provision.sh script") {
            steps {
                echo "Provision and configure web and nginx servers"
                sh './provision.sh -w 2 -i "wlp3s0" -n "192.168.100." -s 100 -l 200'
            }
        }
        stage("Run test.sh script") {
            steps {
                echo "Check ports and services"
                sh './test.sh'
            }
        }
    }
}
