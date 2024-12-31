.data
// New constants and variables for median calculation
    outfile_median: .asciz "medianas.txt"
    
    msg_med_temp_int: .asciz "Mediana Temperatura Interna: "
    msg_med_temp_int_len = . - msg_med_temp_int
    
    msg_med_temp_ext: .asciz "Mediana Temperatura Externa: "
    msg_med_temp_ext_len = . - msg_med_temp_ext
    
    msg_med_nivel: .asciz "Mediana Nivel de Agua: "
    msg_med_nivel_len = . - msg_med_nivel
    
    // Buffers for sorted arrays (5 entries x 8 bytes each)
    temp_interna_sorted: .skip 40
    temp_externa_sorted: .skip 40
    nivel_agua_sorted: .skip 40
    
    // Medianas
    median_temp_int: .double 0.0
    median_temp_ext: .double 0.0
    median_nivel: .double 0.0
    
    // Buffers para strings de medianas
    out_med_temp_int: .skip 32
    out_med_temp_ext: .skip 32
    out_med_nivel: .skip 32
    
    const_two: .double 2.0

    // Constantes adicionales para double_to_string
    const_zero: .double 0.0
    const_hundred: .double 100.0
    digit_table: .asciz "0123456789"
    temp_buffer: .skip 32
    decimal_point: .asciz "."

    msg_temp_int: .asciz "Promedio Temperatura Interna: "
    msg_temp_int_len = . - msg_temp_int


    msg_temp_ext: .asciz "Promedio Temperatura Externa: "
    msg_temp_ext_len = . - msg_temp_ext
    
    msg_nivel: .asciz "Promedio Nivel de Agua: "
    msg_nivel_len = . - msg_nivel
    
    newline: .asciz "\n"
    newline_len = . - newline

    FILE_PERMS = 0644    // rw-r--r--
    O_CREAT = 64         // Valor decimal para O_CREAT
    O_RDWR = 2          // Valor decimal para O_RDWR

    // Archivos
    filename: .asciz "datos.csv"
    outfile: .asciz "promedios.txt"
    
    // Buffers
    buffer: .skip 2048
    
    // Arrays para datos (5 entradas x 8 bytes cada una)
    temp_interna: .skip 40
    temp_externa: .skip 40
    nivel_agua: .skip 40
    
    // Promedios
    avg_temp_int: .double 0.0
    avg_temp_ext: .double 0.0
    avg_nivel: .double 0.0
    
    // Constantes
    const_ten: .double 10.0
    const_point_one: .double 0.1
    const_five: .double 5.0    // Para dividir por 5 (promedio)
    
    // Mensajes
    msg_error: .asciz "Error al abrir archivo\n"
    msg_success: .asciz "Datos leídos correctamente\n"
    
    // Formato para el archivo de salida
    out_format: .ascii "Promedio Temperatura Interna: "
    out_temp_int: .skip 32
    out_newline1: .ascii "\nPromedio Temperatura Externa: "
    out_temp_ext: .skip 32
    out_newline2: .ascii "\nPromedio Nivel de Agua: "
    out_nivel: .skip 32
    out_newline3: .ascii "\n"
    
    // Variables temporales
    .align 4
    fd: .word 0
    outfd: .word 0

.text
.global _start

_start:
    // Guardar registros
    stp x29, x30, [sp, -16]!
    mov x29, sp

    // Abrir archivo
    mov x0, #-100           // AT_FDCWD
    adr x1, filename
    mov x2, #0              // O_RDONLY
    mov x8, #56             // openat
    svc #0
    
    // Verificar error
    cmp x0, #0
    b.lt error_exit
    
    // Guardar file descriptor
    adr x1, fd
    str w0, [x1]
    
    // Leer archivo
    mov x0, x0              // Usar x0 directamente
    adr x1, buffer          // buffer
    mov x2, #2048          // tamaño
    mov x8, #63            // read
    svc #0
    
    // Verificar error
    cmp x0, #0
    b.le error_exit
    
    // Inicializar punteros a arrays
    adr x19, temp_interna
    adr x20, temp_externa
    adr x21, nivel_agua
    
    // Inicializar puntero al buffer
    adr x22, buffer
    mov x23, #0            // contador de líneas
    
    // Saltar primera línea (headers)
skip_header:
    ldrb w0, [x22], #1
    cmp w0, #'\n'
    b.ne skip_header
    
    // Procesar datos
process_data:
    cmp x23, #5            // máximo 5 líneas
    b.ge done_processing
    
    // Saltar fecha y hora (buscar primera coma)
skip_datetime:
    ldrb w0, [x22], #1
    cmp w0, #','
    b.ne skip_datetime
    
    // Leer temperatura interna
    bl read_number
    str d0, [x19, x23, lsl #3]
    
    // Leer temperatura externa
    bl read_number
    str d0, [x20, x23, lsl #3]
    
    // Saltar "Estado del Suelo"
skip_soil:
    ldrb w0, [x22], #1
    cmp w0, #','
    b.ne skip_soil
    
    // Leer nivel de agua
    bl read_number
    str d0, [x21, x23, lsl #3]
    
    // Buscar fin de línea
skip_rest:
    ldrb w0, [x22], #1
    cmp w0, #'\n'
    b.ne skip_rest
    
    add x23, x23, #1
    b process_data
    
done_processing:
    // Calcular promedios
    bl calculate_averages
    
    // Convertir promedios a texto
    bl convert_to_text
    
    // Escribir resultados a archivo
    bl write_to_file
    
    // Cerrar archivo de entrada
    adr x1, fd
    ldr w0, [x1]
    mov x8, #57            // close
    svc #0
    
    mov x0, #0
    b exit

// Función para calcular promedios
calculate_averages:
    stp x29, x30, [sp, -16]!
    mov x29, sp
    
    // Inicializar sumatorias
    fmov d3, xzr          // suma temp_interna
    fmov d4, xzr          // suma temp_externa
    fmov d5, xzr          // suma nivel_agua
    
    mov x0, #0            // contador
    
sum_loop:
    cmp x0, #5
    b.ge end_sum
    
    // Sumar temperatura interna
    adr x1, temp_interna
    ldr d1, [x1, x0, lsl #3]
    fadd d3, d3, d1
    
    // Sumar temperatura externa
    adr x1, temp_externa
    ldr d1, [x1, x0, lsl #3]
    fadd d4, d4, d1
    
    // Sumar nivel de agua
    adr x1, nivel_agua
    ldr d1, [x1, x0, lsl #3]
    fadd d5, d5, d1
    
    add x0, x0, #1
    b sum_loop
    
end_sum:
    // Dividir por 5 para obtener promedios
    adr x0, const_five
    ldr d6, [x0]
    
    fdiv d3, d3, d6
    fdiv d4, d4, d6
    fdiv d5, d5, d6
    
    // Guardar promedios
    adr x0, avg_temp_int
    str d3, [x0]
    adr x0, avg_temp_ext
    str d4, [x0]
    adr x0, avg_nivel
    str d5, [x0]
    
    ldp x29, x30, [sp], #16
    ret

// Función para convertir números a texto
convert_to_text:
    stp x29, x30, [sp, -16]!
    mov x29, sp
    
    // Convertir temperatura interna
    adr x0, avg_temp_int
    ldr d0, [x0]
    adr x0, out_temp_int
    bl double_to_string
    
    // Convertir temperatura externa
    adr x0, avg_temp_ext
    ldr d0, [x0]
    adr x0, out_temp_ext
    bl double_to_string
    
    // Convertir nivel de agua
    adr x0, avg_nivel
    ldr d0, [x0]
    adr x0, out_nivel
    bl double_to_string
    
    ldp x29, x30, [sp], #16
    ret

// Función para escribir a archivo
write_to_file:
    stp x29, x30, [sp, -32]!
    stp x19, x20, [sp, #16]
    mov x29, sp
    
    // Crear archivo de salida
    mov x0, #-100
    adr x1, outfile
    mov x2, #O_CREAT | O_RDWR
    mov x3, #FILE_PERMS
    mov x8, #56
    svc #0
    
    cmp x0, #0
    b.lt write_error
    
    mov x19, x0           // Guardar fd

    // Truncar el archivo a longitud 0
    mov x0, x19
    mov x1, #0
    mov x2, #0
    mov x8, #46           // ftruncate
    svc #0
    
    // Escribir temperatura interna
    mov x0, x19
    adr x1, msg_temp_int
    mov x2, msg_temp_int_len
    mov x8, #64           // write
    svc #0
    
    mov x0, x19
    adr x1, out_temp_int
    mov x2, #32           // longitud máxima
    mov x8, #64
    svc #0
    
    mov x0, x19
    adr x1, newline
    mov x2, #1
    mov x8, #64
    svc #0
    
    // Escribir temperatura externa
    mov x0, x19
    adr x1, msg_temp_ext
    mov x2, msg_temp_ext_len
    mov x8, #64
    svc #0
    
    mov x0, x19
    adr x1, out_temp_ext
    mov x2, #32
    mov x8, #64
    svc #0
    
    mov x0, x19
    adr x1, newline
    mov x2, #1
    mov x8, #64
    svc #0
    
    // Escribir nivel de agua
    mov x0, x19
    adr x1, msg_nivel
    mov x2, msg_nivel_len
    mov x8, #64
    svc #0
    
    mov x0, x19
    adr x1, out_nivel
    mov x2, #32
    mov x8, #64
    svc #0
    
    mov x0, x19
    adr x1, newline
    mov x2, #1
    mov x8, #64
    svc #0
    
    // Cerrar archivo
    mov x8, #57
    mov x0, x19
    svc #0
    
    mov x0, #0
    b write_done

write_error:
    mov x0, #1

write_done:
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret
// Función auxiliar para convertir double a string
double_to_string:
    stp x29, x30, [sp, -64]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp d8, d9, [sp, #48]
    
    mov x19, x0              // Guardar puntero al buffer destino
    fmov d8, d0              // Guardar número original
    
    // Verificar si el número es negativo
    adr x0, const_zero
    ldr d1, [x0]
    fcmp d8, d1
    b.ge positive_number
    
    // Si es negativo, escribir '-' y hacer el número positivo
    mov w0, #'-'
    strb w0, [x19], #1
    fneg d8, d8
    
positive_number:
    // Multiplicar por 100 para manejar 2 decimales
    adr x0, const_hundred
    ldr d1, [x0]
    fmul d9, d8, d1
    
    // Convertir a entero
    fcvtzs x20, d9          // x20 contiene el número * 100
    
    // Preparar para la conversión
    mov x21, x19            // Usar directamente el buffer de salida
    mov x22, #0             // Contador de dígitos
    
    // Procesar los dos decimales primero
    mov x1, #10
    udiv x2, x20, x1
    msub x3, x2, x1, x20
    add w3, w3, #'0'
    strb w3, [x21, x22]
    add x22, x22, #1
    
    mov x20, x2
    udiv x2, x20, x1
    msub x3, x2, x1, x20
    add w3, w3, #'0'
    strb w3, [x21, x22]
    add x22, x22, #1
    
    // Agregar punto decimal
    mov w0, #'.'
    strb w0, [x21, x22]
    add x22, x22, #1
    
    mov x20, x2
    
    
    // Procesar parte entera
process_integer:
    cbz x20, check_zero
    mov x1, #10
    udiv x2, x20, x1
    msub x3, x2, x1, x20
    add w3, w3, #'0'
    strb w3, [x21, x22]
    add x22, x22, #1
    mov x20, x2
    b process_integer

check_zero:
    cmp x22, #3             // Solo punto y decimales
    b.ne reverse_string
    mov w0, #'0'
    strb w0, [x21, x22]
    add x22, x22, #1

reverse_string:
    // Revertir los caracteres
    mov x0, x19             // Inicio
    sub x1, x21, #1         // Fin
    add x1, x1, x22

reverse_loop:
    cmp x0, x1
    b.ge done_reverse
    ldrb w2, [x0]
    ldrb w3, [x1]
    strb w2, [x1]
    strb w3, [x0]
    add x0, x0, #1
    sub x1, x1, #1
    b reverse_loop
    
done_reverse:
    // Agregar terminador nulo
    add x0, x19, x22
    mov w1, #0
    strb w1, [x0]
    
    mov x0, x22             // Devolver longitud
    
    ldp d8, d9, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #64
    ret
    
end_conversion:
    // Si no procesamos ningún dígito entero, poner un 0
    cmp x21, x22
    b.eq write_zero
    
copy_to_output:
    // Copiar los dígitos al buffer final en orden inverso
    mov x0, x19             // Destino
    sub x21, x21, #1        // Último dígito escrito

copy_loop:
    cmp x21, x22
    b.lt done_copy
    ldrb w1, [x21], #-1
    strb w1, [x0], #1
    b copy_loop
    
write_zero:
    mov w0, #'0'
    strb w0, [x19], #1
    
done_copy:
    // Terminar string con null
    mov w0, #0
    strb w0, [x19]
    
    // Calcular y devolver la longitud
    sub x0, x19, x20        // Longitud = posición final - posición inicial
    
    ldp d8, d9, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #64
    ret

error_exit:
    mov x0, #1
    adr x1, msg_error
    mov x2, #20
    mov x8, #64            // write
    svc #0
    
    mov x0, #1

exit:
    ldp x29, x30, [sp], #16
    mov x8, #93            // exit
    svc #0

// Función para leer un número y convertirlo a double
read_number:
    stp x29, x30, [sp, -16]!
    mov x29, sp
    
    // Inicializar resultado
    fmov d0, xzr
    
    // Leer dígitos antes del punto
read_digits:
    ldrb w0, [x22], #1
    cmp w0, #'.'
    b.eq read_decimal
    cmp w0, #','
    b.eq done_reading
    cmp w0, #'\n'
    b.eq done_reading
    
    sub w0, w0, #'0'
    scvtf d1, w0
    
    adr x0, const_ten
    ldr d2, [x0]
    fmul d0, d0, d2
    fadd d0, d0, d1
    b read_digits
    
read_decimal:
    adr x0, const_point_one
    ldr d2, [x0]           // d2 = 0.1
    
read_decimal_digits:
    ldrb w0, [x22], #1
    cmp w0, #','
    b.eq done_reading
    cmp w0, #'\n'
    b.eq done_reading
    
    sub w0, w0, #'0'
    scvtf d1, w0
    fmul d1, d1, d2
    fadd d0, d0, d1
    fmul d2, d2, d2       // siguiente posición decimal
    b read_decimal_digits
    
done_reading:
    ldp x29, x30, [sp], #16
    ret
    