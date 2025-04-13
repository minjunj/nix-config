{ config, lib, ... }:

''
  # Powerlevel10k 즉시 프롬프트 활성화
  if [[ -r "${config.xdg.configHome}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
    source "${config.xdg.configHome}/p10k-instant-prompt-''${(%):-%n}.zsh"
  fi
  
  # Powerlevel10k 설정 - powerlevel10k.txt에서 가져옴
  # 임시로 옵션 변경
  'builtin' 'local' '-a' 'p10k_config_opts'
  [[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
  [[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
  [[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
  'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

  # Powerlevel10k 설정 시작
  () {
    emulate -L zsh -o extended_glob
    unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'
    
    # ASCII 모드 (맥 기본)
    typeset -g POWERLEVEL9K_MODE=ascii
    typeset -g POWERLEVEL9K_ICON_PADDING=none

    # 기본 스타일 설정
    typeset -g POWERLEVEL9K_BACKGROUND=                            # 배경 투명
    typeset -g POWERLEVEL9K_{LEFT,RIGHT}_{LEFT,RIGHT}_WHITESPACE=  # 공백 없음
    typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SUBSEGMENT_SEPARATOR=' '  # 세그먼트 사이 공백
    typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SEGMENT_SEPARATOR=        # 라인 끝 심볼 없음
    
    # 컨텐츠 앞에 아이콘 표시
    typeset -g POWERLEVEL9K_ICON_BEFORE_CONTENT=true
    
    # 프롬프트 앞에 빈 줄 추가 안함 (간결한 표시)
    typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=false
    
    # 왼쪽에 표시할 요소들
    typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
      dir                     # 현재 디렉토리
      vcs                     # git 상태
      prompt_char             # 프롬프트 기호
    )
    
    # 오른쪽에 표시할 요소들
    typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
      status                  # 마지막 명령어 종료 코드
      command_execution_time  # 마지막 명령어 실행 시간
      background_jobs         # 백그라운드 작업 존재 여부
      # 필요한 추가 요소들을 여기에 주석 해제하여 사용할 수 있음
    )
    
    # 디렉토리 표시 설정
    typeset -g POWERLEVEL9K_DIR_FOREGROUND=blue
    typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=blue
    typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=blue
    
    # Git 설정
    typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=green
    typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=yellow
    typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=red
    
    # 상태 표시
    typeset -g POWERLEVEL9K_STATUS_OK=false  # 성공 시 표시 안함
    typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=red
    
    # 프롬프트 문자 설정
    typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND=green
    typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND=red
    
    # 멀티라인 프롬프트 비활성화 (한 줄로 표시)
    typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=
    typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX=
    typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX=
    typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_SUFFIX=
    typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_SUFFIX=
    typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_SUFFIX=
    typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=
  }
  # 원래 옵션 복원
  'builtin' 'unset' 'p10k_config_opts'
  # alias 기능 명시적으로 재활성화
  'builtin' 'setopt' 'aliases'
''
