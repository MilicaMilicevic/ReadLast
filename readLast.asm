;Read some file path and then write last 10 characters on console.Inform about error while opening.

SECTION .data
message	db	10,'Cannot open file.',10
message_lenght	equ	$-message

SECTION .bss
path	resb	100	;assume it will be enough
result	resb	10

SECTION .text
global _start
_start:

read_path:
      MOV	EAX,3
      MOV	EBX,0
      MOV 	ECX,path
      MOV 	EDX,100
      INT	80h		;in EAX is number of chars that have been read

modify_path:	;make sure it's terminated with 0
      MOV 	BYTE[path+EAX-1],0	;-1 to overwrite \n

open_file:
      MOV 	EAX,5
      MOV 	EBX,path
      MOV 	ECX,0		;read-only
      INT 	80h		;in EAX is fileId or negative in case od error

CMP 	EAX,0
JL 	write_error


positioning:
      MOV 	EBX,EAX	;get fileId
      MOV 	EAX,19
      MOV 	ECX,-10
      MOV 	EDX,2		;start calculating based on the end of file!
      INT 	80h

read_chars:
      MOV 	EAX,3		;in ebx is already fileid
      MOV 	ECX,result
      MOV 	EDX,10
      INT 	80h

close_file:
      MOV 	EAX,6
      INT 	80h

write_chars:
      MOV 	EAX,4
      MOV 	EBX,1
      MOV 	ECX,result
      MOV 	EDX,10
      INT 	80h

write_error:		;if file can't be opened
      MOV 	EAX,4
      MOV 	EBX,1
      MOV 	ECX,message
      MOV 	EDX,message_lenght
      INT 	80h

end:
  MOV	EAX,1
  MOV 	EBX,0
  INT 	80h
