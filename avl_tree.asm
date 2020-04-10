%include "io.inc"

extern malloc
extern free
extern printf
extern scanf

section .data
	INTF db "%d", 0
	STRF db "%s", 0
	SPACE db " ", 0
	ENDL db 10, 0
	input db "ADSPF"

section .text

print_int:
	push ebp
	mov ebp, esp
	sub esp, 8

	mov eax, [ebp + 8]
	mov [esp + 4], eax
	mov dword[esp], INTF

	call printf

	leave
	ret

read_int:
	push ebp
	mov ebp, esp
	sub esp, 8

	mov eax, [ebp + 8]
	mov [esp + 4], eax
	mov dword[esp], INTF

	call scanf

	leave
	ret

read_str:
	push ebp
	mov ebp, esp
	sub esp, 8

	mov eax, [ebp + 8]
	mov [esp + 4], eax
	mov dword[esp], STRF

	call scanf

	leave
	ret

global main
main:

	xor eax, eax
	ret

;|	struct node {
;|		int key, data;
;|		struct node *left, *right;
;|		int height;
;|	}

;|	pnode newNode(int key, int value) {
;|		pnode new = malloc(sizeof(node));
;|	
;|		new->key = key;
;|		new->value = value;
;|		new->left = NULL;
;|		new->right = NULL;
;|		new->height = 1;
;|	
;|		return new;
;|	}

newNode:
	push ebp
	mov ebp, esp
	sub esp, 8

	mov dword[esp], 20

	call malloc

	mov edx, [ebp + 8]
	mov [eax], edx

	mov edx, [ebp + 12]
	mov [eax + 4], edx

	mov dword[eax + 8], 0
	mov dword[eax + 12], 0
	mov dword[eax + 16], 1

	leave
	ret

;|	int height(pnode t) {
;|		if (!t)
;|			return 0;
;|	
;|		return t->height;
;|	}

height:; -fomit-frame-pointer
	mov eax, [esp + 4]
	test eax, eax
	jnz .else
		xor eax, eax
		jmp .return
	.else:
		mov eax, [eax + 16]

.return:
	ret

;|	int diff(pnode t) {
;|		return height(t->left) - height(t->right);
;|	}

diff:
	push ebp
	mov ebp, esp
	sub esp, 8

	mov eax, [ebp + 8]
	mov eax, [eax + 12]
	mov [esp], eax
	call height

	mov [ebp - 4], eax

	mov eax, [ebp + 8]
	mov eax, [eax + 8]
	mov [esp], eax
	call height

	sub eax, [ebp - 4]
	leave
	ret


;|	int max(int a, int b) {
;|		return (a > b ? a : b);
;|	}

max:; -fomit-frame-pointer
	mov eax, [esp + 4]
	mov ebx, [esp + 8]

	cmp eax, ebx
	cmovl eax, ebx

	ret

;|	void update(pnode t) {
;|		t->height = max(height(t->left), height(t->right)) + 1;
;|	}

update:
	push ebp
	mov ebp, esp
	sub esp, 8

	mov eax, [ebp + 8]
	mov eax, [eax + 8]
	mov [esp], eax
	call height

	mov [esp + 4], eax

	mov eax, [ebp + 8]
	mov eax, [eax + 12]
	mov [esp], eax
	call height

	mov [esp], eax
	call max

	inc eax

	mov edx, [ebp + 8]
	mov [edx + 16], eax

	leave
	ret

;|	pnode rotateLeft(pnode t) {
;|		pnode r = t->right;
;|		t->right = r->left;
;|		r->left = t;
;|	
;|		update(t);
;|		update(r);
;|	
;|		return r;
;|	}

rotateLeft:
	push ebp
	mov ebp, esp
	sub esp, 8

	mov eax, [ebp + 8]
	mov eax, [eax + 12]
	mov [ebp - 4], eax

	mov edx, [eax + 8]
	mov eax, [ebp + 8]
	mov [eax + 12], edx

	mov edx, [ebp + 8]
	mov eax, [ebp - 4]
	mov [eax + 8], edx

	mov eax, [ebp + 8]
	mov [esp], eax
	call update

	mov eax, [ebp - 4]
	mov [esp], eax
	call update

	mov eax, [ebp - 4]
	leave
	ret

;|	pnode rotateRight(pnode t) {
;|		pnode l = t->left;
;|		t->left = l->right;
;|		l->right = t;
;|	
;|		update(t);
;|		update(l);
;|	
;|		return l;
;|	}

rotateRight:
	push ebp
	mov ebp, esp
	sub esp, 8

	mov eax, [ebp + 8]
	mov eax, [eax + 8]
	mov [ebp - 4], eax

	mov edx, [eax + 12]
	mov eax, [ebp + 8]
	mov [eax + 8], edx

	mov edx, [ebp + 8]
	mov eax, [ebp - 4]
	mov [eax + 12], edx

	mov eax, [ebp + 8]
	mov [esp], eax
	call update

	mov eax, [ebp - 4]
	mov [esp], eax
	call update

	mov eax, [ebp - 4]
	leave
	ret

;|	pnode bigRotateLeft(pnode t) {
;|		t->right = rotateRight(t->right);
;|		return rotateLeft(t);
;|	}

bigRotateLeft:
	push ebp
	mov ebp, esp
	sub esp, 4

	mov eax, [ebp + 8]
	mov eax, [eax + 12]
	mov [esp], eax
	call rotateRight

	mov edx, [ebp + 8]
	mov [edx + 12], eax

	mov eax, [ebp + 8]
	mov [esp], eax
	call rotateLeft

	leave
	ret

;|	pnode bigRotateRight(pnode t) {
;|		t->left = rotateLeft(t->left);
;|		return rotateRight(t);
;|	}

bigRotateRight:
	push ebp
	mov ebp, esp
	sub esp, 4

	mov eax, [ebp + 8]
	mov eax, [eax + 8]
	mov [esp], eax
	call rotateLeft

	mov edx, [ebp + 8]
	mov [edx + 8], eax

	mov eax, [ebp + 8]
	mov [esp], eax
	call rotateRight

	leave
	ret

;|	pnode balanced(pnode t) {
;|		if (diff(t) == -2) {
;|			if (diff(t->right) == 1)
;|				t = bigRotateLeft(t);
;|			else
;|				t = rotateLeft(t);
;|		}
;|		else if (diff(t) == 2) {
;|			if (diff(t->left) == -1)
;|				t = bigRotateRight(t);
;|			else
;|				t = rotateRight(t);
;|		}
;|	
;|		return t;
;|	}

balanced:
	push ebp
	mov ebp, esp
	sub esp, 4

	mov eax, [ebp + 8]
	mov [esp], eax
	call diff

	cmp eax, -2
	jne .else_if

		mov eax, [ebp + 8]
		mov eax, [eax + 12]
		mov [esp], eax
		call diff

		mov edx, [ebp + 8]
		mov [esp], edx

		cmp eax, 1
		jne .smallRotateLeft

			call bigRotateLeft
			jmp .return

		.smallRotateLeft:

			call rotateLeft
			jmp .return

	.else_if:
	cmp eax, 2
	jne .else

		mov eax, [ebp + 8]
		mov eax, [eax + 8]
		mov [esp], eax
		call diff

		mov edx, [ebp + 8]
		mov [esp], edx

		cmp eax, -1
		jne .smallRotateRight

			call bigRotateRight
			jmp .return

		.smallRotateRight:

			call rotateRight
			jmp .return

	.else:

		mov eax, [ebp + 8]

.return:
	leave
	ret

;|	pnode insert(pnode t, int key, int value) {
;|		if (!t)
;|			t = newNode(key, value);
;|	
;|		if (key < t->key)
;|			t->left = insert(t->left, key, value);
;|		else if (key > t->key)
;|			t->right = insert(t->right, key, value);
;|		else
;|			t->value = value;
;|
;|		update(t);
;|		return balanced(t);
;|	}

insert:
	push ebp
	mov ebp, esp
	sub esp, 24

	mov eax, [ebp + 8]
	test eax, eax
	jnz .end_if_1
		mov eax, [ebp + 12]
		mov edx, [ebp + 16]

		mov [esp], eax
		mov [esp + 4], edx

		call newNode

		jmp .return
		.end_if_1:

	mov eax, [ebp + 12]
	mov edx, [ebp + 16]

	mov [esp + 4], eax
	mov [esp + 8], edx

	mov edx, [ebp + 12]
	mov eax, [ebp + 8]
	cmp edx, [eax]

	jge .else_if_2

		mov edx, [eax + 8]
		mov [esp], edx

		call insert

		mov edx, [ebp + 8]
		mov [edx + 8], eax

		mov eax, edx
		jmp .return

	.else_if_2:
	jle .else_2

		mov edx, [eax + 12]
		mov [esp], edx

		call insert

		mov edx, [ebp + 8]
		mov [edx + 12], eax

		mov eax, edx
		jmp .return

	.else_2:

		mov edx, [ebp + 16]
		mov [eax + 4], edx

.return:

	mov [esp], eax
	call update
	call balanced

	leave
	ret

;|	void find(pnode t, int key) {
;|		if (!t)
;|			return;
;|	
;|		if (key < t->key)
;|			find(t->left, key);
;|		else if (key > t->key)
;|			find(t->right, key);
;|		else 
;|			printf("%d %d\n", t->key, t->value);
;|	}

find:
	push ebp
	mov ebp, esp
	sub esp, 8

	mov eax, [ebp + 8]
	test eax, eax
	jz .return

	mov edx, [ebp + 12]
	cmp edx, [eax]
	jge .else_if_1

		mov eax, [eax + 8]
		mov [esp], eax
		mov [esp + 4], edx

		call find

		jmp .return

	.else_if_1:
	jle .else_1

		mov eax, [eax + 12]
		mov [esp], eax
		mov [esp + 4], edx

		call find

		jmp .return

	.else_1:

		mov edx, [eax]
		mov [esp], edx

		call print_int
		
		mov dword[esp], SPACE
		call printf

		mov eax, [ebp + 8]
		mov edx, [eax + 4]
		mov [esp], edx

		call print_int
		
		mov dword[esp], ENDL
		call printf

.return:
	leave
	ret

;|	pnode predecessor(pnode t) {
;|		t = t->left;
;|		while (t->right)
;|			t = t->right;
;|		return t;
;|	}

predecessor:
	push ebp
	mov ebp, esp

	mov eax, [ebp + 8]
	mov eax, [eax + 8]

	mov edx, [eax + 12]
	.while_1:
		test edx, edx
		jz .end_while_1

		mov eax, edx
		mov edx, [eax + 12]

		jmp .while_1
	.end_while_1:

	leave
	ret

;|	pnode successor(pnode t) {
;|		t = t->right;
;|		while (t->left)
;|			t = t->left;
;|		return t;
;|	}

successor:
	push ebp
	mov ebp, esp

	mov eax, [ebp + 8]
	mov eax, [eax + 12]

	mov edx, [eax + 8]
	.while_1:
		test edx, edx
		jz .end_while_1

		mov eax, edx
		mov edx, [eax + 8]

		jmp .while_1
	.end_while_1:

	leave
	ret

;|	pnode delete(pnode t, int key) {
;|		node subst;
;|	
;|		if (!t)
;|			return NULL;
;|	
;|		if (key < t->key)
;|			t->left = delete(t->left, key);
;|		else if (k > t->key)
;|			t->right = delete(t->right, key);
;|		else {
;|			if (t->left) {
;|				copy(predecessor(t), &subst);
;|				t->left = delete(t->left, subst.key);
;|			}
;|			else if (t->right) {
;|				copy(successor(t), &subst);
;|				t->right = delete(t->right, subst.key);
;|			}
;|			else {
;|				free(t);
;|				t = NULL;
;|			}
;|
;|			copy(&subst, t);
;|
;|			update(t);
;|			t = balanced(t);
;|		}
;|	
;|		return t;
;|	}

delete:
	push ebp
	mov ebp, esp
	sub esp, 24

	mov eax, [ebp + 8]
	test eax, eax
	jz .return

	mov eax, [ebp + 12]
	mov [esp + 4], eax

	mov edx, [ebp + 12]
	mov eax, [ebp + 8]
	cmp edx, [eax]

	jge .else_if_2

		mov edx, [eax + 8]
		mov [esp], edx
		call delete

		mov edx, [ebp + 8]
		mov [edx + 8], eax

		mov eax, edx
		jmp .return

	.else_if_2:
	jle .else_2

		mov edx, [eax + 12]
		mov [esp], edx
		call delete

		mov edx, [ebp + 8]
		mov [edx + 12], eax

		mov eax, edx
		jmp .return

	.else_2:

		mov edx, [eax + 12]
		mov eax, [eax + 8]

		test eax, eax
		jz .else_if_3

			mov eax, [ebp + 8]
			mov [esp], eax
			call predecessor

			mov edx, [eax]
			mov [esp + 8], edx

			mov edx, [eax + 4]
			mov [esp + 12], edx

			mov edx, [eax + 16]
			mov [esp + 16], edx

			mov eax, [ebp + 8]
			mov eax, [eax + 8]
			mov [esp], eax

			mov eax, [esp + 8]
			mov [esp + 4], eax
			call delete

			mov edx, [ebp + 8]
			mov [edx + 8], eax

			jmp .end_if_3

		.else_if_3:
		test edx, edx
		jz .else_3

			mov eax, [ebp + 8]
			mov [esp], eax
			call successor

			mov edx, [eax]
			mov [esp + 8], edx

			mov edx, [eax + 4]
			mov [esp + 12], edx

			mov edx, [eax + 16]
			mov [esp + 16], edx

			mov eax, [ebp + 8]
			mov eax, [eax + 12]
			mov [esp], eax

			mov eax, [esp + 8]
			mov [esp + 4], eax
			call delete

			mov edx, [ebp + 8]
			mov [edx + 12], eax

			jmp .end_if_3

		.else_3:

			mov eax, [ebp + 8]
			mov [esp], eax
			call free

			xor eax, eax
			jmp .return

		.end_if_3:

		mov eax, [ebp + 8]

		mov edx, [esp + 8]
		mov [eax], edx

		mov edx, [esp + 12]
		mov [eax + 4], edx

		mov edx, [esp + 16]
		mov [eax + 16], edx

		mov eax, [ebp + 8]

		mov [esp], eax
		call update
		call balanced

.return:
	leave
	ret

;|	void free_tree(pnode t) {
;|		if (!t)
;|			return;
;|	
;|		free_tree(t->left);
;|		free_tree(t->right);
;|		free(t);
;|	}

free_tree:
	push ebp
	mov ebp, esp
	sub esp, 8

	mov eax, [ebp + 8]
	test eax, eax
	jz .return
		mov eax, [ebp + 8]
		mov eax, [eax + 8]
		mov [esp], eax
		call free_tree

		mov eax, [ebp + 8]
		mov eax, [eax + 12]
		mov [esp], eax
		call free_tree

		mov eax, [ebp + 8]
		mov [esp], eax
		call free

.return:
	leave
	ret

;|	void print_tree(pnode t) {
;|		if (!t)
;|			return;
;|	
;|		print_tree(t->left);
;|		print_int(t->value);
;|		print_tree(t->right);
;|	}

print_tree:
	push ebp
	mov ebp, esp
	sub esp, 8

	mov eax, [ebp + 8]
	test eax, eax
	jz .return
		mov eax, [ebp + 8]
		mov eax, [eax + 8]
		mov [esp], eax
		call print_tree

		mov eax, [ebp + 8]
		mov eax, [eax + 4]
		mov [esp], eax
		call print_int
		
		mov dword[esp], SPACE
		call printf

		mov eax, [ebp + 8]
		mov eax, [eax + 16]
		mov [esp], eax
		call print_int

		mov dword[esp], ENDL
		call printf

		mov eax, [ebp + 8]
		mov eax, [eax + 12]
		mov [esp], eax
		call print_tree

.return:
	leave
	ret