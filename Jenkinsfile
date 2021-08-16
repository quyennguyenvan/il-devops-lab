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
            s3Upload(pathStyleAccessEnabled: true, payloadSigningEnabled: true, file:'iindex.html', bucket:S3BUCKET, path:'index.html')
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