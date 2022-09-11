# 2장 스프링 부트에서 테스트 코드를 작성하자

- TDD와 단위테스트의 차이
  - `TDD`: 테스트가 주도하는 개발, 테스트 코드를 먼저 작성하는 것
    - 항상 실패하는 테스트를 먼저 작성
    - 테스트가 통과하는 프로덕션 코드 작성
    - 테스트가 통과하면 프로덕션 코드 리팩토링
  - `단위테스트(Unit Test)`: 기능 단위의 테스트 코드를 작성하는 것
    - 순수하게 테스트 코드만 작성하는 것
- 테스트 코드 작성의 이점
  - 빠른 피드백
  - 자동검증
  - 새로운 기능이 추가되었을 때 기존 기능이 잘 작동되는 것 보장

- 기본 기능 구현하기
  - `src/main/java` 디렉토리에서 새 패키지 생성
  - 일반적으로 패지키명은 웹사이트 주소의 역순 (`com.seohyun.book.springboot`)
  - `Application` 클래스는 메인 클래스
    - `@SpringBootApplication`으로 스프링부트 자동 설정 및 스프링 Bean 읽기 생성 모두 자동 설정됨
    - 프로젝트의 최상단에 위치해야함
    - `SpringApplication.run`으로 내장 WAS 실행
      - 톰캣 설치할 필요 없음
      - 스프링 부트로 만들어진 Jar(Java 패키징 파일)로 실행하면 됨
      - 언제나 같은 환경에서 스프링 부트를 배포할 수 있음
  - `Controller`
    - `@RestController`
      - JSON을 반환하는 컨트롤러
    - `@GetMapping`
      - HTTP Method인 Get 요청을 받을 수 있는 API 만들어줌

- 테스트 코드 작성하기
  - `@RunWith(SpringRunner.class)`
    - JUnit에 내장된 실행자 외에 다른 실행자를 실행시킴
    - SpringRunner라는 스프링 실행자를 사용함
    - 스프링 부트 테스트와 JUnit 사이의 연결자 역할
    - JUnit5에서는 `ExtendWith()`을 사용함
  - `@WebMvcTest`
    - Spring MVC Controllers가 예상대로 동작하는지 테스트할 때 사용
    - 특정 어노테이션을 가진 Beans만 스캔함
      - Web에 집중할 수 있는 어노테이션
      - `@Controller`, `@ControllerAdvice`, `@JsonComponent` 등
  - `@Autowired`
    - 스프링 DI에 사용되는 어노테이션
    - 스프링이 관리하는 Bean을 주입 받음
  - `private MockMvc mvc`
    - 웹 API 테스트 시에 사용하며 GET, POST 등에 대한 API 테스트 가능
  - `mvc.perform(get("/hello"))`
    - `/hello` 주소로 HTTP GET 요청을 보냄
    - 체이닝으로 여러 검증을 이어서 선언할 수 있음
  - `.andExpect(status().isOk()`
    - HTTP Header의 Status를 검증함   
  - `.andExpect(content().string(hello))`
    - response 본문의 내용을 검증함

- 롬복 (Lombok)으로 테스트 코드 전환하기
  - Getter, Setter, 기본생성자, toString 등을 어노테이션을 자동 생성해줌
  - `implementation('org.projectlombok:lombok')`
  - `@Getter()`
    - 선언된 모든 필드의 get 메소드를 생성해줌
  - `@RequiredArgsConstructor`
    - 선언된 모든 final 필드가 포함된 생성자를 생성해줌
    - final이 없는 필드는 생성자에 포함되지 않음
  - `@assertThat()`
    - assertj라는 테스트 검증 라이브러리의 검증 메소드
    - 검증하고싶은 대상을 메소드 인자로 받음
    - 메소드 체이닝 지원
  - `@isEqualTo()`
    - assertj의 동등 비교 메소드
    - assertThat에 있는 값과 isEqualTo의 값을 비교해서 같을때만 성공
  - assertj의 장점
    - 추가적인 라이브러리가 필요없음
    - IDE에서 자동완성 지원 편의성

- 추가로 설정한 내용들
  - Gradle 7.x 버전에서 Lombok 사용하기
    - 책은 Gradle 4버전을 사용하고 있어서 책대로 설정하면 에러가 발생한다.
    - 버전을 낮추긴 싫으니, 7버전대에서 Lombok 사용법을 추가로 공부함
    - `build.gradle`에 아래 코드를 추가함
      ```
      dependencies {
        compileOnly 'org.projectlombok:lombok'
        annotationProcessor 'org.projectlombok:lombok'
        testCompileOnly 'org.projectlombok:lombok'
        testAnnotationProcessor 'org.projectlombok:lombok'
      }    
      ```
  - JUnit 테스트명이 안나오는 문제 해결하기
    - Settings - Build, Execution, Deployment - Build tools - Gradle - Run tests using "IntelliJ IDEA"로 설정