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

    stage('Artifact Management') {
      parallel {
        stage('Archive HTML Artifacts') {
          steps {
            archiveArtifacts(artifacts: 'docs/index.html, **/*.xml', fingerprint: true)
          }
        }
        stage('Archive JUnit Artifacts') {
          steps {
            junit(testResults: '**/*.xml', checksName: 'Archive JUnit test results', healthScaleFactor: 1, allowEmptyResults: true, skipPublishingChecks: true)
          }
        }
        stage('Publish HTML Results') {
          steps {
            script {
              publishHTML(target: [
                allowMissing: false,
                alwaysLinkToLastBuild: false,
                keepAll: true,
                reportDir: 'docs',
                reportFiles: 'index.html',
                reportTitles: "Model Advisor Report",
                reportName: "Model Advisor Report"
              ])
            }

          }
        }

      }
    }

  }
}