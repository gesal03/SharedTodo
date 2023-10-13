![image](https://github.com/gesal03/SharedTodo/assets/77336664/4a8f18f4-77b2-414d-84e1-ffe576c0170c)![image](https://github.com/gesal03/SharedTodo/assets/77336664/64075c1c-24d3-4468-8917-7c6cef4b03e6)# SharedTodo
📱 2023 IOS Term Project - Shared Todo

## 개요
여러 사람과의 협업 시 업무를 공유하는 것은 핵심 사항이다.<br>
매번 업무 완료 보고를 하고, 진행사항을 공지하는 것은 꽤나 번거로운 일이다. <br>
본 어플리케이션은 이러한 상황 속에 업무 일정, 목록을 효율적으로 공유하는데 목적이 있다.<br>
User 정보에 부서명을 포함하고 있어 로그인 시, 해당 부서의 업무 목록과 일정을 볼 수 있다.<br>
또한, 해당 부서원만 해당 부서의 업무 목록, 일정을 등록할 수 있고, Tab을 통해 부서원 목록과 해당 User의 정보를 볼 수 있다.<br>

## 구조
<img width="493" alt="image" src="https://github.com/gesal03/SharedTodo/assets/77336664/cc7cc3be-4674-4529-95b6-2bdc45087c10">

## 기능
### 로그인
Firebase User에 등록된 User Data를 가져와 사용자가 입력한 id, password와 <br>
등록된 User data의 id, password와 비교해 일치하면 Tab Bar Controller로 전이한다.<br>
<img width="136" alt="image" src="https://github.com/gesal03/SharedTodo/assets/77336664/f2344872-be19-4ec2-95aa-e1c08bc1e35e">

### 회원가입
Id, password, 부서명(dept), 직책(Position)을 입력하여 User 객체를 만들어 Firebase에 저장한다.<br>
<img width="211" alt="image" src="https://github.com/gesal03/SharedTodo/assets/77336664/70bead7f-1bc3-4565-8ffc-6260b54ead40">

### Todo List
Todo List는 총 두가지의 Table로 나뉜다. <br>
첫 Todo List는 업무(schedule) 목록을 나타내며, 두번째 Todo List는 일정(meeting)이 나타낸다.<br>
각 Table 모두 삭제가 가능하며, 각 Table 옆 + 버튼을 통해 Todo를 추가할 수 있다.<br>
또한, FSCalendar를 통해 다른 날짜에 업무 목록과 일정을 등록할 수 있으며, 날짜를 클릭해 해당 날짜의 Todo List를 조회할 수 있다. 추가로, 각 날짜의 일정 수는 FSCalendar의 나타난다.<br>
마지막으로, 어플리케이션 상단에 해당 날짜의 업무 목록과 일정 중 완료, 미완료 Todo 개수가 나타난다.<br>
업무나 일정 완료 시Todo List 좌측의 체크 버튼을 클릭해 완료 상태로 만들 수 있으며, 그 개수는 상단의 Label에 나타난다.<br>
#### Todo List View
<img width="235" alt="image" src="https://github.com/gesal03/SharedTodo/assets/77336664/de0bc2fd-0943-4fba-9fc1-0046edd2d17b">
#### 일정 등록 View
<img width="210" alt="image" src="https://github.com/gesal03/SharedTodo/assets/77336664/4f7e147b-2b04-4bfd-a796-37098b5dea8f">

### Department Info
해당 ViewController에서는 User가 속해 있는 부서의 구성원을 볼 수 있다. <br>
해당 구성원의 부서, 이름, 직책명이 출력된다.<br>
<img width="193" alt="image" src="https://github.com/gesal03/SharedTodo/assets/77336664/705c652d-6a10-4f81-b0e6-c582f8a90571">


### UserInfo
현재 로그인 된 User의 정보가 출력된다. User의 이름, 직책, 부서명이 출력된다.<br>
<img width="166" alt="image" src="https://github.com/gesal03/SharedTodo/assets/77336664/cf1b84b3-3822-4a62-b602-808ed055d2a3">

