# Contributing

## Pull Request Process

1. github 에서 이 repository 를 내 계정으로 fork 합니다.
이제부터 이 repository 는 ORIGINAL REPOSITORY, fork 한 repository 는 FORK REPOSITORY 라고 하겠습니다. 
2. 내 로컬에서 FORK REPOSITORY 를 clone 하고 디렉토리를 이동합니다.
    ```
    $ git clone https://github.com/YOUR_USERNAME/zcp-monitoring.git
    $ cd zcp-monitoring
    ```
3. 내 로컬에서 ORIGINAL REPOSITORY 는 `upstream` 으로 remote 를 추가합니다.
    ```
    $ git remote add upstream https://github.com/cnpst/zcp-monitoring.git
    ```
    > 만약 내 로컬에서 이미 ORIGINAL REPOSITORY 를 clone 했다면 이름을 변경하고 추가합니다.
    ```
    $ git remote rename origin upstream
    $ git remote add origin https://github.com/YOUR_USERNAME/zcp-monitoring.git
    $ git checkout master
    $ git branch -u origin
    ```
4. 정상적으로 추가되었는지 확인합니다.
    ```
    $ git remote -v
    origin    https://github.com/YOUR_USERNAME/zcp-monitoring.git (fetch)
    origin    https://github.com/YOUR_USERNAME/zcp-monitoring.git (push)
    upstream  https://github.com/cnpst/zcp-monitoring.git (fetch)
    upstream  https://github.com/cnpst/zcp-monitoring.git (push)
    ```
5. 추가한 upstream 을 fetch 합니다.
    ```
    $ git fetch upstream
    From https://github.com/cnpst/zcp-monitoring
     * [new branch]      master               -> upstream/master
    ```
6. FORK REPOSITORY 의 master, 즉 `origin/master` 에서 새로운 branch 를 생성합니다.
만약 새로운 branch 를 _feature_ 라고 한다면 
    ```
    $ git checkout -b feature
    ```
7. 해당 branch 에서 개발을 하고 add, commit, push 를 합니다.
    ```
    $ git add <files>
    $ git commit -m "commit message"
    $ git push origin feature
    ```
8. 개발을 완료하면 github 에서 해당 branch 를 ORIGINAL REPOSITORY 의 master 로 pull request 합니다.
9. ORIGINAL REPOSITORY 에서 merge 가 완료되면 upstream 정보를 갱신합니다.
    ```
    $ git fetch upstream
    remote: Enumerating objects: 4, done.
    remote: Counting objects: 100% (4/4), done.
    remote: Compressing objects: 100% (4/4), done.
    remote: Total 4 (delta 0), reused 0 (delta 0), pack-reused 0
    Unpacking objects: 100% (4/4), done.
    From https://github.com/cnpst/zcp-monitoring
       04ee9ea..2820c86  master     -> upstream/master
    ```
10. FORK REPOSITORY 의 master 에서 ORIGINAL REPOSITORY 의 master 와 merge 하여 동기화합니다.
    ```
    $ git checkout master
    Switched to branch 'master'
    $ git merge upstream/master
    ```
11. FORK REPOSITORY 의 원격 master, 즉 github 에 반영합니다.
    ```
    $ git push origin master
    ```
12. 필요하다면 해당 branch 를 삭제합니다. 만약 cherry-pick 이 되어야 할 branch 라면 남겨 둡니다.
    ```
    $ git branch -D feature
    Deleted branch feature.
    $ git push origin :feature
    To https://github.com/YOUR_USERNAME/zcp-monitoring.git
     - [deleted]         feature
    ```
feature 개발은 6 ~ 12 를 반복합니다.

## Code of Conduct

@TODO