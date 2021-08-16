pipeline {
  agent none

  environment {
    S3BUCKET = "s3-static-web-job-tf"
    region = "ap-northeast-1"
  }

  stages {
    stage("publish") {
      agent { node {label 'master'}}
      steps {
        sh "ls -ll"
        pwd();
        withAWS(region:region,credentials:'aws-credential') {
          
        }
      }
    }
  }

  post {
    success {
      echo "SUCCESSFUL"
    }
    failure {
      echo "FAILED"
    }
  }
}