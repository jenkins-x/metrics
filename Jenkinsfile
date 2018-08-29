pipeline {
    environment {
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
                dir ('/home/jenkins/metrics') {
                    checkout scm
                    container('jx-base') {
                        sh "helm init --client-only"

                        sh "make build"
                        sh "helm template ."
                    }
                }
            }
        }
    
        stage('Build and Push Release') {
            when {
                branch 'master'
            }
            steps {
                dir ('/home/jenkins/metrics') {
                    checkout scm
                    container('jx-base') {
                        sh "jx step git credentials"
                        sh "./jx/scripts/release.sh"
                    }
                }
            }
        }
    }
    post {
        always {
            cleanWs()
        }
    }
}
