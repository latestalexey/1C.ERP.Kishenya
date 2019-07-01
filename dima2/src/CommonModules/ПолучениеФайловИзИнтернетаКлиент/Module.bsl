////////////////////////////////////////////////////////////////////////////////
// Подсистема "Получение файлов из Интернета".
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Получает файл из Интернета по протоколу http(s), либо ftp и сохраняет его по указанному пути на клиенте.
//
// Параметры:
//   URL                - Строка - url файла в формате [Протокол://]<Сервер>/<Путь к файлу на сервере>.
//   ПараметрыПолучения - Структура со свойствами:
//      * ПутьДляСохранения    - Строка       - путь на сервере (включая имя файла), для сохранения скачанного файла.
//      * Пользователь         - Строка       - пользователь от имени которого установлено соединение.
//      * Пароль               - Строка       - пароль пользователя от которого установлено соединение.
//      * Порт                 - Число        - порт сервера с которым установлено соединение.
//      * Таймаут              - Число        - таймаут на получение файла, в секундах.
//      * ЗащищенноеСоединение - Булево       - признак использования защищенного соединения ftps или https.
//                             - ЗащищенноеСоединение - см. описание свойства ЗащищенноеСоединение объектов
//                             FTPСоединение и HTTPСоединение.
//                             - Неопределено - в случае, если защищенное соединение не используется.
//      * ПассивноеСоединение  - Булево       - для случая ftp загрузки флаг указывает, что соединение должно пассивным
//                                              (или активным).
//      * Заголовки            - Соответствие - см. описание параметра Заголовки объекта HTTPЗапрос.
//   ЗаписыватьОшибку   - Булево - Признак необходимости записи ошибки в журнал регистрации при получении файла.
//
// Возвращаемое значение:
//   Структура - Структура со свойствами:
//      * Статус            - Булево - результат получения файла.
//      * Путь   - Строка   - путь к файлу на сервере, ключ используется только если статус Истина.
//      * СообщениеОбОшибке - Строка - сообщение об ошибке, если статус Ложь.
//      * КодСостояния      - Число - Добавляется при возникновении ошибки.
//                                    См. описание параметра КодСостояния объекта HTTPОтвет.
//
Функция СкачатьФайлНаКлиенте(Знач URL, Знач ПараметрыПолучения = Неопределено, Знач ЗаписыватьОшибку = Истина) Экспорт
	
	НастройкиПолучения = ПолучениеФайловИзИнтернетаКлиентСервер.СтруктураПараметровПолученияФайла();
	
	Если ПараметрыПолучения <> Неопределено Тогда
		
		ЗаполнитьЗначенияСвойств(НастройкиПолучения, ПараметрыПолучения);
		
	КонецЕсли;
	
	НастройкаСохранения = Новый Соответствие;
	НастройкаСохранения.Вставить("МестоХранения", "Клиент");
	НастройкаСохранения.Вставить("Путь", НастройкиПолучения.ПутьДляСохранения);
	
	Возврат ПолучениеФайловИзИнтернетаКлиентСервер.ПодготовитьПолучениеФайла(URL, НастройкиПолучения, НастройкаСохранения, ЗаписыватьОшибку);
	
КонецФункции

// Открывает форму для ввода параметров прокси сервера.
//
Процедура ОткрытьФормуПараметровПроксиСервера() Экспорт
	
	ОткрытьФорму("ОбщаяФорма.ПараметрыПроксиСервера");
	
КонецПроцедуры

#КонецОбласти
