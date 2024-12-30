.data
    csv_filename:    .string "datos.csv"
    buffer:         .skip 4096        // Buffer para manejar los 10 registros
    output_msg:     .string "El archivo CSV se ha leído correctamente.\nSe encontraron los siguientes datos:\n\nEncabezados:\n- Fecha y Hora\n- Temperatura Interna (°C)\n- Temperatura Externa (°C)\n- Estado del Suelo\n- Nivel de Agua\n- Sistema de Riego\n- Sistema de Ventilación\n\nNúmero de registros leídos: 10\n"
    output_len = . - output_msg
    error_msg:      .string "Error al abrir el archivo CSV.\n"
    error_len = . - error_msg

    // Mensajes del menú (sin cambios)
    menu:       .string "\n=== MENU PRINCIPAL ===\n1. Nombres de integrantes\n2. Análisis Estadístico\n3. Exportar resultados\n4. Salir\nOpción: "
    menu_len = . - menu
    
    // Nombres de integrantes (sin cambios)
    nombres:    .string "\nIntegrantes del grupo:\n\n1. Henry David Quel Santos - 202004071\n2. Pablo Alejandro Marroquin Cutz - 202200214\n3. Eric David Rojas de Leon - 202200331\n4. Jore Alejandro de Leon Batres - 202111277\n5. Roberto Miguel Garcia Santizo - 202201724\n6. Jose Javier Bonilla Salazar - 202200035\n7. Gerardo Leonel Ortiz Tobar - 202200196\n8. David Isaac García Mejía - 202202077\n\n"
    nombres_len = . - nombres
    
    num_datos = 10            // Actualizado a 10 registros
    // Buffer para entrada
    input_buffer: .skip 8
    // Archivo de salida
    filename:   .string "resultados.txt"
    // Mensajes de análisis
    msg_analisis: .string "\n=== RESULTADOS DEL ANÁLISIS ===\n"
    msg_export:  .string "\nResultados exportados a 'resultados.txt'\n"
    msg_invalid: .string "\nOpción inválida. Intente de nuevo.\n"

.text
.global _start
_start:
menu_loop:
    // Mostrar menú
    mov x0, #1                  // stdout
    ldr x1, =menu
    ldr x2, =menu_len
    mov x8, #64                 // syscall write
    svc 0
    // Leer opción
    mov x0, #0                  // stdin
    ldr x1, =input_buffer
    mov x2, #2                  // leer 2 bytes (número + enter)
    mov x8, #63                 // syscall read
    svc 0
    // Procesar opción
    ldrb w0, [x1]
    sub w0, w0, #48            // Convertir ASCII a número
    // Menú principal
    cmp w0, #1
    beq mostrar_nombres
    cmp w0, #2
    beq analisis_estadistico
    cmp w0, #3
    beq exportar_resultados
    cmp w0, #4
    beq salir
    // Opción inválida
    b opcion_invalida
mostrar_nombres:
    // Mostrar nombres
    mov x0, #1
    ldr x1, =nombres
    ldr x2, =nombres_len
    mov x8, #64
    svc 0
    b menu_loop
analisis_estadistico:
    bl leer_csv
    b menu_loop
exportar_resultados:
    // Exportar a archivo
    bl exportar_a_archivo
    b menu_loop
opcion_invalida:
    mov x0, #1
    ldr x1, =msg_invalid
    mov x2, #35
    mov x8, #64
    svc 0
    b menu_loop
salir:
    mov x0, #0
    mov x8, #93                // syscall exit
    svc 0
calcular_estadisticas:
    stp x29, x30, [sp, -16]!
    mov x29, sp
    // Aquí irían los cálculos reales
    // Por ahora solo mostramos el mensaje
    mov x0, #1
    ldr x1, =msg_analisis
    mov x2, #33
    mov x8, #64
    svc 0
    ldp x29, x30, [sp], 16
    ret
exportar_a_archivo:
    stp x29, x30, [sp, -16]!
    mov x29, sp
    // Crear archivo
    mov x0, #-100              // AT_FDCWD
    ldr x1, =filename
    mov x2, #0x241            // O_WRONLY | O_CREAT | O_TRUNC
    mov x3, #0644             // permisos
    mov x8, #56               // syscall openat
    svc 0
    // Mostrar mensaje de confirmación
    mov x0, #1
    ldr x1, =msg_export
    mov x2, #40
    mov x8, #64
    svc 0
    ldp x29, x30, [sp], 16
    ret
leer_csv:
    stp x29, x30, [sp, -16]!
    mov x29, sp

    // Abrir archivo CSV
    mov x0, #-100              // AT_FDCWD
    ldr x1, =csv_filename
    mov x2, #0                 // O_RDONLY
    mov x8, #56               // syscall openat
    svc 0

    // Verificar si hubo error
    cmp x0, #0
    b.lt error_lectura

    // Si se abrió correctamente, crear archivo de salida
    mov x4, x0                // Guardar file descriptor del CSV
    
    // Crear archivo de resultado
    mov x0, #-100              // AT_FDCWD
    ldr x1, =filename         // resultados.txt
    mov x2, #0x241            // O_WRONLY | O_CREAT | O_TRUNC
    mov x3, #0644             // permisos
    mov x8, #56               // syscall openat
    svc 0

    // Escribir mensaje de éxito al archivo
    mov x1, x0                // File descriptor para escribir
    mov x0, x1
    ldr x1, =output_msg
    ldr x2, =output_len
    mov x8, #64               // syscall write
    svc 0

    // Cerrar archivo CSV
    mov x0, x4
    mov x8, #57               // syscall close
    svc 0

    ldp x29, x30, [sp], 16
    ret

error_lectura:
    // Mostrar mensaje de error
    mov x0, #1                // stdout
    ldr x1, =error_msg
    ldr x2, =error_len
    mov x8, #64               // syscall write
    svc 0
    
    ldp x29, x30, [sp], 16
    ret
