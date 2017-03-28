def flow

stage '\u263A Dev Build'
node("build-slave")
{
    def accountName = "leixu"
    def credentialsId = "910ebc52-5f6b-4ca2-9bf4-748e040c96cb"
    def repoName = "demo-voting"
    def harborProjectName = "vote"
    def testServer = "demotest.eastasia.cloudapp.azure.com"
    def swarmMasterServer = "swarm-bkrrrmkmijq7y-manage.eastasia.cloudapp.azure.com"
    
    def jobName = "${env.JOB_NAME}"
    def jobNum = "{env.BUILD_NUMBER}"

    git branch: "master", credentialsId: "${credentialsId}", url: "git@gitlab.devopshub.cn:${accountName}/${repoName}.git"

    sh "mvn -f ./worker/pom.xml package"
    
    sh "docker build -f ./worker/Dockerfile.j -t harbor-bj.devopshub.cn/${harborProjectName}/worker:latest ./worker"
    sh "docker build -f ./vote/Dockerfile -t harbor-bj.devopshub.cn/${harborProjectName}/vote:latest ./vote"
    sh "docker build -f ./result/Dockerfile -t harbor-bj.devopshub.cn/${harborProjectName}/result:latest ./result"

    sh "docker login -u user -p Tr@1n1ng harbor-bj.devopshub.cn"
    sh "docker push harbor-bj.devopshub.cn/${harborProjectName}/worker:latest"
    sh "docker push harbor-bj.devopshub.cn/${harborProjectName}/vote:latest"
    sh "docker push harbor-bj.devopshub.cn/${harborProjectName}/result:latest"

    
    stage name: 'Test Stag', concurrency: 1
    timeout(time:1, unit:"DAYS")
    {
        input message: "Everything build successfully?"
    }

    sshagent (credentials: ["${credentialsId}"]) {
        def sshhost = "ssh azureuser@${testServer}"
        sh "$sshhost \"docker-compose -f docker-compose.inittest.yml pull vote && docker-compose -f docker-compose.inittest.yml up -d --no-deps vote\""
    }
    
    stage name: 'Production Stag', concurrency: 1
    timeout(time:1, unit:"DAYS")
    {
        input message: "Did all tests pass?"
    }

    sshagent (credentials: ["${credentialsId}"]) {
        def sshswarm = "ssh -p 2200 azureuser@${swarmMasterServer}" 
        sh "$sshswarm \"docker service update --image harbor-bj.devopshub.cn/${harborProjectName}/vote:latest vote_vote\""
    }
    
}