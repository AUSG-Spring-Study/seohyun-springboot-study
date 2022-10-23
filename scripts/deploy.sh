REPOSITORY=/home/ec2-user/app/step1
PROJECT_NAME=seohyun-springboot-study

cd $REPOSITORY/$PROJECT_NAME/

echo "&gt; Git Pull"

git pull

echo "&gt; 프로젝트 Build 시작"

./gradlew build

echo "&gt;step1 디렉토리로 이동"

cd $REPOSITORY

echo "&gt; Build 파일복사"

cp $REPOSITORY/$PROJECT_NAME/build/libs/*.jar $REPOSITORY/

echo "&gt; 현재 구동중인 애플리케이션 pid 확인"

CURRENT_PID=$(pgrep -f ${PROJECT_NAME}.*.jar)

echo "현재 구동중인 애플리케이션 pid 확인"

if [ -z "$CURRENT_PID" ]; then
        echo "&gt; 현재 구동 중인 애플리케이션이 없으므로 종료하지 않습니다."
else
        echo "&gt; kill -15 $CURRENT_PID"
        kill -15 $CURRENT_PID
        sleep 5
fi

echo "&gt; 새 애플리케이션 배포"

JAR_NAME=$(ls -tr $REPOSITORY/ | grep jar | tail -n 1)

echo "&gt; JAR Name: $JAR_NAME"

nohup java -jar $REPOSITORY/$JAR_NAME 2>&1 &