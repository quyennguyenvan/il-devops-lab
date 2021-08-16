pipeline {

  agent none

  environment {
    DOCKER_IMAGE = "482976502347.dkr.ecr.ap-northeast-1.amazonaws.com/il_py_app"
  }

  stages {
    stage("build_and_publish") {
      agent { node {label 'master'}}
      environment {
        DOCKER_TAG="${GIT_BRANCH.tokenize('/').pop()}-${GIT_COMMIT.substring(0,7)}"
      }
      steps {
        sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} . "
        sh "docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest"
        sh "docker image ls | grep ${DOCKER_IMAGE}"
        sh "echo remove the older docker container"
        sh "docker stop app-test && docker rm app-test"
        sh "docker run -d --name app-test -p 5000:5000 ${DOCKER_IMAGE}:${DOCKER_TAG}"
        withDockerRegistry("https://"+DOCKER_IMAGE,'ecr:ap-northeast-1:aws-credential') {
            sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
            sh "docker push ${DOCKER_IMAGE}:latest"
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