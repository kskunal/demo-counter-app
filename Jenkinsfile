pipeline{
    agent any
    tools {
        maven 'Maven3.9.4'
    }
    stages {
        stage('Git Checkout'){
            steps{
                git branch: 'main', url: 'https://github.com/kskunal/demo-counter-app.git'
            }
        }
        stage('Unit Testing'){
            steps{
                sh 'mvn test'
            }
        }
        stage('Intergration  Testing'){   
            steps{
                sh 'mvn verify -DskipUnitTests'
            }
        }
        stage('Maven Build'){
            steps{
                sh 'mvn clean install'
            }
        }
        stage('Static code analysis'){
            steps{
                script{
                    withSonarQubeEnv(credentialsId: 'Sonar-Token') {
                    sh 'mvn clean package sonar:sonar'
                    }
                }
            }
        }
        stage('Quality Gate Status'){
            steps{
                script{
                    waitForQualityGate abortPipeline: false, credentialsId: 'Sonar-Token'
                }
            }
        }
        stage("uplaod war file to nexus"){
            steps{
                script{
                    def readPom = readMavenPom file: 'pom.xml'
                    // switch the repository
                    def nexusrepo=readPom.version.endsWith("SNAPSHOT")? "demo-counter-snapshot" :"demo-counter-release"
                    nexusArtifactUploader artifacts: 
                    [
                        [
                            artifactId: "${readPom.artifactId}", 
                            classifier: '', 
                            file: 'target/Uber.jar', 
                            type: 'jar'
                        ]
                    ], 
                    credentialsId: 'nexus_id', 
                    groupId: "${readPom.groupId}", 
                    nexusUrl: '4.213.70.240:8081', 
                    nexusVersion: 'nexus3', 
                    protocol: 'http', 
                    repository: nexusrepo, 
                    version: "${readPom.version}"
                }
            }
        }
        stage("Build Docker images"){
            steps{
                script{
                    sh 'docker build -t ksauto82/$JOB_NAME:v1.$BUILD_ID .'
                    sh 'docker run -d -p 8888:9099 --name $JOB_NAME-$BUILD_ID ksauto82/$JOB_NAME:v1.$BUILD_ID'
                }
            }
        }
        stage("Push to Docker registory"){
            steps{
                script{
                    withCredentials([usernamePassword(credentialsId: 'dockerhub_credential', passwordVariable: 'dockerpwd', usernameVariable: 'dockeruid')]) {
                        echo "login into the DockerHub"
                        sh 'docker login -u ${dockeruid}  -p ${dockerpwd}'
                        echo "Pushing the Image to the DockerHub"
                        sh 'docker push ${dockeruid}/$JOB_NAME:v1.$BUILD_ID'
                    }
                }
            }
        }
        
    }
}

