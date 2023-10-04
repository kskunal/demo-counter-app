pipeline{
agent
stages{
	stage('Git Checkout'){
		steps{
			script{
				git branch: 'main', url: 'https://github.com/kskunal/demo-counter-app.git'
			}
		}
	}
}
}
