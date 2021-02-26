pipeline {
  agent any
  stages {
    stage('Run Model Advisor') {
      parallel {
        stage('Generate HTML Report') {
          steps {
            runMATLABCommand 'run(\'simulink_tests_01\')'
          }
        }

        stage('Generate JUnit Result') {
          steps {
            runMATLABCommand 'run(\'simulink_tests_02\')'
          }
        }

      }
    }

    stage('Archive Artifacts') {
      steps {
        junit(testResults: '**/*.xml', checksName: 'Archive JUnit test results', keepLongStdio: true, healthScaleFactor: 1)
        archiveArtifacts(artifacts: 'report/report.html', fingerprint: true)
      }
    }

  }
}