pipeline {
    environment {
        GH_CREDS = credentials('jenkins-x-github')
        CHARTMUSEUM_CREDS = credentials('jenkins-x-chartmuseum')
    }
    agent {
        label "jenkins-jx-base"
    }
    stages {
        stage('CI Build') {
            when {
                branch 'PR-*'
            }
            steps {
                container('jx-base') {
                    sh "helm init --client-only"

                    sh "make build"
                    sh "helm template ."
                }
            }
        }
    
        stage('Build and Push Release') {
            when {
                branch 'master'
            }
            steps {
                container('jx-base') {
                    sh "./jx/scripts/release.sh"
                }
            }
        }
    }
}
