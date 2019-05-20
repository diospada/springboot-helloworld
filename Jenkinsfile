@Library('pipeline-library-demo')_

def versionFromPom() {
 	def matcher = readFile('pom.xml') =~ '<version>(.+?)</version>'
 	matcher ? matcher[0][1] : null
}

def artifactFromPom() {
 	def matcher = readFile('pom.xml') =~ '<artifactId>(.+?)</artifactId>'
 	matcher ? matcher[0][1] : null
}

def installationDir = "C:\\test"
def urlGitRepository = "https://github.com/diospada/springboot-helloworld.git"
def serviceName = ""
def versionName = ""
def jarName = ""


pipeline {
    agent {
       label 'window10slave'
    }
    stages {
        stage('checkout') {
            steps {
                 echo "checkout from repository branch=${env.BRANCH_NAME}.."
                 cleanWs() 
                 checkout([$class: 'GitSCM', branch: "${env.BRANCH_NAME}", doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: "${urlGitRepository}"]]])
            }
        }
        stage('Building') {
            steps {
                echo 'Building..'
                withMaven(maven : 'maven_3.5.4') {
                    bat 'mvn clean compile'
                }
            }
        }
        stage('Package') {
            steps {
                echo 'Package..'
                withMaven(maven : 'maven_3.5.4') {
                    bat 'mvn package install'
                    script{
                        versionName = versionFromPom();
                        serviceName = artifactFromPom();
                        jarName = "${serviceName}-${versionName}"
                    }
                    echo "mvn package install versionName=${versionName} serviceName=${serviceName} jarName=${jarName}"
                }
            }
        }
        stage('Copy artifact') {
            steps {
                echo 'Copy artifact..'
                copyArtifacts filter: '**/*.jar', fingerprintArtifacts: true, flatten: true, projectName: "${env.JOB_NAME}", target: "${installationDir}", selector: specific("${currentBuild.number}")
            }
        }

        stage('Install as windows service') {
            steps {
               deployWindowsService (serviceName: "${serviceName}", jarName: "${jarName}", installationDir : "${installationDir}")
            }
        }
}

}
