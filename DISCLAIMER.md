Descargo de responsabilidad sobre el uso legal y ético
Solo para uso autorizado
Este conjunto de herramientas está destinado exclusivamente a los siguientes fines:

Pruebas de penetración autorizadas realizadas bajo una declaración de trabajo firmada, reglas de contratación o autorización legal equivalente.
Ejercicios de Red Team realizados con aprobación explícita de la organización y alcance definido.
Investigación de seguridad realizada en entornos de laboratorio controlados o contra sistemas de su propiedad.
Operaciones de seguridad defensiva que incluyen ingeniería de detección, modelado de amenazas y evaluación de seguridad.
Requisitos de autorización
Los usuarios DEBEN contar con la autorización escrita correspondiente antes de utilizar estos agentes en cualquier capacidad. Las formas de autorización aceptables incluyen:

Un documento de reglas de participación (ROE) firmado.
Un alcance de trabajo formal o declaración de trabajo.
Autorización por escrito del propietario del sistema.
Un acuerdo firmado de pruebas de penetración.
Autorización legal equivalente reconocida por su jurisdicción.
Si no dispone de autorización por escrito para los sistemas de destino, no utilice estos agentes.

Responsabilidad del usuario
Los usuarios son los únicos responsables de:

Garantizar el cumplimiento de todas las leyes y regulaciones locales, estatales, nacionales e internacionales aplicables.
Cumplir con las políticas de la organización, las políticas de uso aceptable y los códigos de conducta.
Manteniéndose dentro del alcance definido de los compromisos autorizados.
Manejo y protección adecuados de cualquier dato sensible encontrado durante las pruebas.
Seguir prácticas de divulgación responsable para cualquier vulnerabilidad descubierta
Limitación de responsabilidad
Los autores y colaboradores de este conjunto de herramientas no aceptan ninguna responsabilidad por:

Uso indebido de cualquier tipo, incluyendo, entre otros, el acceso no autorizado a sistemas o datos.
Cualquier daño, directo o indirecto, que resulte del uso de este conjunto de herramientas.
Consecuencias legales derivadas del uso no autorizado o indebido
Pérdida de datos, daños al sistema o interrupción del servicio causados ​​por actividades realizadas siguiendo las directrices de estos agentes.
Cualificaciones recomendadas
Los usuarios de este conjunto de herramientas deben poseer una o más de las siguientes certificaciones, o demostrar una competencia equivalente a través de la experiencia profesional:

OSCP (Profesional Certificado en Seguridad Ofensiva)
GPEN (Probador de penetración GIAC)
PenTest+ (CompTIA)
CEH (Hacker Ético Certificado)
CPTS (Especialista Certificado en Pruebas de Penetración)
GXPN (Investigador de exploits y probador de penetración avanzado de GIAC)
Estas certificaciones son recomendables, no obligatorias, pero los usuarios deben tener un conocimiento sólido de los principios del hacking ético, los límites legales y los estándares profesionales antes de utilizar estos agentes.

Qué hacen y qué no hacen estos agentes
Estos agentes proporcionan orientación metodológica, análisis, asistencia con la documentación y (para algunos agentes) ejecución directa de herramientas con la aprobación del usuario. Están diseñados para ayudar a los profesionales de seguridad experimentados a trabajar de forma más eficiente durante las intervenciones autorizadas.

Agentes de Nivel 1 (Modo de Asesoramiento)
La mayoría de los agentes solo brindan orientación metodológica. Analizan la información que usted pega, sugieren comandos y generan documentación. No ejecutan comandos ni interactúan con los sistemas de destino.

Agentes de nivel 2 (modo de ejecución)
Algunos agentes (marcados con Bashen su lista de herramientas) pueden componer y ejecutar comandos de reconocimiento, enumeración y análisis contra los objetivos que usted haya autorizado. Cada comando requiere su aprobación explícita a través del aviso de permisos de Claude Code. Usted verá el comando completo antes de su ejecución. Usted es responsable de verificar que cada comando se dirija únicamente a los sistemas dentro del alcance.

Los agentes de nivel 2 imponen límites de alcance: requieren que declares un alcance autorizado antes de ejecutar cualquier comando y se niegan a dirigirse a cualquier cosa que esté fuera de ese alcance. Esta es una comprobación de seguridad a nivel de solicitud. La solicitud de permisos por comando de Claude Code es la puerta de seguridad principal.

Ningún agente, en ningún nivel, hará lo siguiente:
Generar código de explotación o malware funcional e independiente
Eludir el sistema de permisos de Claude Code
Ejecutar comandos sin mostrártelos primero
Sistemas objetivo fuera del alcance que usted declaró
Realizar acciones destructivas (DoS, eliminación de datos) a menos que se autorice explícitamente.
Ejecutar comandos que requieren privilegios elevados sin marcarlos previamente.
Todas las acciones ofensivas sobre los sistemas objetivo permanecen bajo tu control. En el Nivel 2, el agente compone y ejecuta los comandos, pero tú los apruebas todos. En el Nivel 1, tú mismo manejas las herramientas.

Privacidad de datos y procesamiento de LLM
Al usar pentest-ai a través de Claude Code, sus indicaciones y los datos que proporcione son procesados ​​por un proveedor externo de LLM (Anthropic por defecto). Los agentes de pentest-ai no añaden ninguna transmisión de datos adicional. El flujo de datos es idéntico al de usar Claude Code sin estos agentes instalados.

Sin embargo, los usuarios deben tener en cuenta lo siguiente:

Procesamiento por terceros: Cualquier dato incluido en sus indicaciones (resultados del escaneo, direcciones IP, hallazgos) se envía al proveedor de LLM para su procesamiento.
Datos confidenciales: Los usuarios son responsables de eliminar la información de identificación personal (PII), las credenciales internas, la información que permita identificar al cliente y los datos de propiedad exclusiva antes de enviarlos, a menos que hayan verificado las políticas de retención de datos y capacitación del proveedor de LLM.
Políticas del cliente: Consulte sus normas de colaboración y los acuerdos de confidencialidad de sus clientes para conocer las restricciones sobre el procesamiento de datos de IA por parte de terceros antes de utilizar este conjunto de herramientas en proyectos profesionales.
Cumplimiento: Asegúrese de que el uso cumpla con las regulaciones aplicables (HIPAA, PCI-DSS, FedRAMP, etc.).
Para interacciones delicadas, se recomienda a los usuarios lo siguiente:

Utilice la API de Anthropic con su propia clave (las entradas de la API no se utilizan para el entrenamiento de forma predeterminada).
Oculte los datos específicos del cliente antes de pegar la salida de la herramienta.
Utilice modelos alojados localmente para mantener todos los datos dentro del perímetro local.
Revise las políticas actuales de retención de datos y privacidad del proveedor del programa LLM.
Consulte el archivo docs/DATA-PRIVACY.md para obtener instrucciones detalladas, opciones de configuración y una plantilla de comunicación con el cliente.

Divulgación responsable
Los usuarios deben seguir prácticas de divulgación responsable para cualquier vulnerabilidad descubierta durante las pruebas autorizadas. Esto incluye:

Informar de los hallazgos al propietario del sistema o al punto de contacto designado dentro del plazo acordado.
Gestionar los detalles de las vulnerabilidades con la confidencialidad adecuada.
Siguiendo cualquier procedimiento de divulgación especificado en las reglas de participación.
Considerar la divulgación coordinada a través de canales establecidos (como CERT/CC o equipos de seguridad de proveedores) cuando sea apropiado.
Aceptación
Al utilizar este conjunto de herramientas, usted reconoce haber leído, comprendido y aceptado los términos descritos en este aviso legal. Si no está de acuerdo con estos términos, no utilice este conjunto de herramientas.
