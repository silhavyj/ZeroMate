.global spinlock_init
.global spinlock_try_lock
.global spinlock_unlock

.equ Lock_Locked,   1
.equ Lock_Unlocked, 0

;@ Inicializace spinlocku
;@ Na danou adresu vlozime hodnotu "odemceno"
;@ r0 - adresa zamku
spinlock_init:
    mov r12, #Lock_Unlocked
    str r12, [r0]
    bx lr

;@ Pokus o zamceni zamku
;@ Provede pokus o zamceni, vraci puvodni hodnotu zamku - pokud se zamceni povedlo, je vracena hodnota "odemceno"
;@ r0 - adresa zamku
spinlock_try_lock:
    ;@ "neatomicky" lock - tady by mohlo dojit k prusvihu, kdyz bude proces preplanovan mezi instrukcemi "ldr" a "str"
    ;@ pak by mohl zamek nekdo vyfouknout a to co by melo byt exkluzivni by najednou mohly vlastnit dva procesy, to nechceme
    ;@ TODO: pouzit ldrex a strex instrukce
    mov r12, r0
    mov r1, #Lock_Locked

    ldr r0, [r12]
    cmp r0, #Lock_Unlocked
    streq r1, [r12]
    bx lr

;@ Odemceni zamku
;@ Odemkne zamek - nastavi hodnotu "odemceno"
;@ neoveruje, zda byl zamek predtim zamceny! O to se stara logika vnejsiho kodu
;@ r0 - adresa zamku
spinlock_unlock:
    mov r12, #Lock_Unlocked
    str r12, [r0]
    bx lr
