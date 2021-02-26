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
        stage('Archive Artifacts') {
          steps {
            junit(testResults: '**/*.xml', checksName: 'Archive JUnit test results', healthScaleFactor: 1, allowEmptyResults: true, skipPublishingChecks: true)
            archiveArtifacts(artifacts: 'report/report.html', fingerprint: true)
          }
        }

        stage('Publish HTML Results') {
          steps {
            script {
              publishHTML(target: [
                allowMissing: false,
                alwaysLinkToLastBuild: false,
                keepAll: true,
                reportDir: 'coverage',
                reportFiles: 'docs/index.html',
                reportTitles: "Simulink Model Advisor Report",
                reportName: "Model Advisor Report"
              ])
            }

          }
        }

      }
    }

  }
}