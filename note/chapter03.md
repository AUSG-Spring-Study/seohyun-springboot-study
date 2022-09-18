# 3장 스프링 부트에서 JPA로 데이터베이스 다뤄보자

- JPA(자바 표준 ORM: Object Relational Mapping)
  - 객체를 관계형 데이터베이스에서 관리하는 것
  - `SQL`의 단점
    - 애플리케이션 코드보다 SQL을 더 많이 작성하게 되었음
    - 단순 반복 작업을 수백 번 해야함 (DB 저장, 조회, 수정 등)
    - 관계형 데이터 베이스와 객체지향 프로그래밍의 패러다임 불일치
      - 관계형 데이터 베이스: 어떻게 데이터를 저장할까?
      - 객체지향 프로그래밍 언어: 기능과 속성을 한 곳에서 관리
      ```
      // 객체지향 프로그래밍
      User user = findUser();
      Group group = user.getGroup();
      
      // DB가 추가된다면?
      User user = userDao.findUser();
      Group group = groupDao.findGroup(user.getGroupId());
      ```
      - User도 조회하고, Group도 조회해야함
      - 웹 애플리케이션 개발의 중심이 `데이터 베이스 모델링`이 되어버림 -> JPA의 등장
    - `JPA`는 관계형 데이터 베이스에 맞게 SQL을 대신 생성해주는 역할을 함

- Spring Data JPA
  - 대표적인 구현체: `Hibernate`, `Eclipse Link`(예제에서는 `Spring Data JPA`를 사용함)
  - JPA <- Hibernate <- Spring Data JPA
    - 구현체 교체의 용이성(Hibernate 이외의 다른 구현체)
    - 저장소 교체의 용이성(관계형 데이터베이스 외의 다른 저장소)
  - JPA의 단점
    - 높은 러닝 커브
    - 객체지향 프로그래밍과 관계형 데이터베이스 모두 알아야함
  - JPA의 장점
    - CRUD 쿼리를 직접 작성할 필요가 없음
    - 부모 자식 관계 / 1:N 관계 표현 / 상태와 행위를 한 곳에서 관리를 쉽게 할 수 있음
    - 구현만 잘 한다면 네이티브 쿼리만큼의 퍼포먼스를 낼 수 있음

---
- 프로젝트
  - Spring Data JPA 적용하기
    - `spring-boot-starter-data-jpa`: JPA 관련 라이브러리 버전 관리
    - `h2`: 인메모리 관계형 데이터베이스, 애플리케이션 재시작 시 초기화 되므로 테스트용으로 많이 사용함
    - `domain 패키지`
      - 게시글, 댓글, 회원, 정산, 결제 등 SW에 대한 요구사항, 문제영역을 포함함
    - Posts 클래스
      - 어노테이션 순서는 자유지만 이 책에서는 주요 어노테이션을 클래스에 가깝게 둔다.
      - 어노테이션
        - @Entity
          - 테이블과 링크될 클래스임을 나타냄
        - @Id
          - 해당 테이블의 Primary Key 필드를 나타냄
          - PK는 Long 타입의 Auto_increment를 추천함
          - unique key 혹은 여러 키로 조합한 복합키로 PK를 잡게되면 난감한 상황이 발생하기 때문
            - 복합키를 전부 갖고있거나 중간 테이블을 하나 더 둬야하는 상황 발생
            - 인덱스에 좋은 영향을 끼치지 못함
            - unique 조건이 변경되면 PK 전체를 수정해야함
        - @GeneratedValue
          - PK의 생성 규칙을 나타냄
          - `GenerationType.IDENTITY` 옵션 추가를 해야 auto_increment 됨
        - @Column
          - 선언하지 않더라도 해당 클래스의 필드는 모두 칼럼이 됨
          - 기본값 외에 추가 변경이 필요한 옵션이 있으면 사용함
        - @NoArgsConstructor
          - 기본 생성자 자동 추가
        - @Getter
          - 클래스 내 모든 필드의 Getter 메소드 자동 생성
        - @Builder
          - 해당 클래스의 빌더 패턴 클래스 생성
          - 생성자 상단에 선언 시 생성자에 포함된 필드만 빌더에 포함
      - Entity 클래스에서는 절대로 Setter 메소드를 만들지 않음
        - 해당 클래스의 인스턴스 값이 언제 어디서 변해야하는지 구분하기 힘듬
        - 차후 기능 변경 시 복잡해짐
        - 값 변경이 필요하면 목적과 의도를 나타낼 수 있는 메소드를 추가하는 방식으로 구현해야함
        ```
        // bad
        public void 주문서비스의_취소이벤트() {
          order.setStatus(false);
        }
        
        // good
        public void 주문서비스의_취소이벤트() {
          order.cancelOrder();
        }
        ```
        - 생성자를 통해 최종값을 채운 후 DB에 삽입
        - 값 변경 필요하면 해당 이벤트에 맞는 public 메소드 호출
        ```
        public Example(String a, String b) {
          this.a = a;
          this.b = b;
        }
        
        // 코드 실행전까지는 문제점을 찾기 힘듬
        new Example(a,b);
        new Example(b,a);
        
        // 빌더를 사용하면 어느 필드에 어떤값을 채워야하는지 명확해짐
        Example.builder()
          .a(a)
          .b(b)
          .build();
        ```
    - PostsRepository
      - Posts 클래스로 DB에 접근하게 해줄 JpaRepository
      - Dao(DB Layer 접근자), JPA에서는 Repository라고 부름
  - Spring Data JPA 테스트 코드 작성하기
    - @After
      - JUnit 단위 테스트가 끝날 때마다 수행되는 메소드
      - 테스트간 데이터 침범을 막기 위해 사용
    - postsRepository.save
      - 테이블 posts에 insert/update 쿼리를 실행함
      - id 값이 있다면 update, 없으면 insert 쿼리 실행
    - postsRepository.findAll
      - 테이블 posts에 있는 모든 데이터 조회하는 메소드
    - @SpringBootTest를 사용하면 H2 데이터베이스를 자동으로 실행해줌
    - `application.properties` 파일을 생성하고 옵션을 추가하면 실제 실행된 쿼리 형태를 볼 수 있음
      ```
      // 콘솔에서 쿼리 로그를 확인할 수 있음
      Hibernate: insert into posts (id, author, content, title) values (null, ?, ?, ?)
      Hibernate: select posts0_.id as id1_0_, posts0_.author as author2_0_, posts0_.content as content3_0_, posts0_.title as title4_0_ from posts posts0_
      Hibernate: select posts0_.id as id1_0_, posts0_.author as author2_0_, posts0_.content as content3_0_, posts0_.title as title4_0_ from posts posts0_
      Hibernate: delete from posts where id=?
      ```
  - API 만들기
    - 세 개의 클래스가 필요함
      - Request 데이터를 받을 DTO
      - API 요청을 받을 Controller
      - 트랜잭션, 도메인 기능 간의 순서를 보장하는 Service
        - Service는 트랜잭션, 도메인 간 순서 보장 역할만 수행
        - 비즈니스 로직은?
          - Web Layer
            - controller, JSP/Freemarker 등의 뷰 템플릿 영역
            - filter, interceptor, controller, controlleradvice
            - 외부 요청과 응답에 대한 전반적인 영역
          - Service Layer
            - @Service에 사용되는 영역
            - Controller, Dao의 중간 영역에서 사용됨
            - @Transactional이 사용되어야하는 영역
          - Repository Layer
            - Database와 같이 데이터 저장소에 접근하는 영역
          - Dtos
            - 계층 간의 데이터 교환을 위한 객체
            - 뷰 템플릿 엔진에서 사용될 객체나 Repository Layer에서 결과로 넘겨준 객체 등
          - Domain Model
            - 모든 사람이 동일한 관점에서 이해할 수 있고 공유할 수 있도록 단순화시킨 것
            - 비즈니스 처리를 담당해야하는 곳
    - PostsApiController
    - PostsService
      - 생성자로 주입받는 방식
      - @RequiredArgsConstructor
        - final이 선언된 모든 필드를 인자값으로 하는 생성자를 대신 생성해줌
        - lombok annotation을 사용하는 이유는 의존성 관계가 변경될 때마다 생성자 코드를 계속해서 수정하는 번거로움을 해결하기 위함
    - Entity 클래스와 Controoler에서 쓸 DTO는 분리해서 사용해야함
    - 수정/조회 기능
      - update 기능에서 DB에 쿼리 날리는 부분이 없는데, JPA의 영속성 컨텍스트 때문이다
      - 영속성 컨텍스트
        - 엔티티를 영구 저장하는 환경
        - 트랜잭션 안에서 데이터베이스로부터 데이터를 가져오면 영속성 컨텍스트가 유지된 상태
        - 트랜잭션이 끝나는 시점에서 해당 테이블에 변경분이 반영됨
        - dirty checking
      - application.properties에 H2 콘솔 옵션을 추가함
        - 메모리에서 실행되므로 웹 콘솔을 통해 접근
        - Application의 main()을 실행시키면 `localhost:8080/h2-console`로 접속 가능
        - 직접 쿼리를 실행시킬 수도 있음
  - JPA Auditing으로 생성/수정 시간 자동화하기
    - domain 패키지에 BaseTimeEntity 클래스 생성
      - 모든 Entity의 상위 클래스가 되어 Entity들의 createdDate, modifiedDate를 자동으로 관리하는 역할
      - @EnableJpaAuditing 어노테이션을 추가하여 설정 가능