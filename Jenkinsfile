pipeline{
	agent any
	tools {
  maven 'Maven3.9.4'
}

	stages {
		stage('Git Checkout'){
			steps{
				script{
					git branch: 'main', url: 'https://github.com/kskunal/demo-counter-app.git'
				}
			}
		}
                stage('Unit Testing'){
                        steps{
                                script{
                                        sh 'mvn test'
                                }
                        }
                }
	}
}
