
#Область ПрограммныйИнтерфейс

// Читает с сервера почтовые сообщения.
//
// Параметры:
//  УчетнаяЗапись - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты - Учетная запись используемая для загрузки сообщений.
//  ГлубинаПоиска - Число - Глубина просмотра почтовых сообщений от текущей даты, в днях.
//  МаксимальныйРазмерПисьма - Число - Максимальный размер загружаемых сообщений, в мегабайтах.
//
// Возвращаемое значение:
//  ТаблицаЗначений - Состав колонок таблицы значений см. СоздатьАдаптированноеОписаниеПисьма().
//
Функция ПрочитатьПисьма(Параметры) Экспорт
	
	Письма = СоздатьАдаптированноеОписаниеПисьма();
	
	ОдинМегабайтВБайтах = 1048576;
	Если Параметры.Свойство("МаксимальныйРазмерПисьма") Тогда
		МаксимальныйРазмерПисьма = Параметры.МаксимальныйРазмерПисьма;
		
	Иначе
		МаксимальныйРазмерПисьма = 2;
		
	КонецЕсли;
	
	МаксимальныйРазмерПисьма = МаксимальныйРазмерПисьма * ОдинМегабайтВБайтах;
	
	УчетнаяЗапись = Параметры.УчетнаяЗапись;
	
	Протокол = ПротоколИнтернетПочты.POP3;
	Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(УчетнаяЗапись, "ПротоколВходящейПочты") = "IMAP" Тогда
		Протокол = ПротоколИнтернетПочты.IMAP;
	КонецЕсли;
	
	Соединение = ОтправкаПочтовыхСообщений.УстановитьСоединениеССервером(УчетнаяЗапись, Истина, Протокол);
	Если Соединение = Неопределено Тогда
		Возврат Письма;
	КонецЕсли;
	
	Если Параметры.Свойство("ГлубинаПоиска") И Параметры.ГлубинаПоиска > 0 Тогда
		ПослеДатыОтправления = КонецДня(ТекущаяДатаСеанса()) - 60 * 60 * 24 * Параметры.ГлубинаПоиска + 1;
	Иначе
		ПослеДатыОтправления = '00010101';
	КонецЕсли;
	
	ПараметрыОтбораЗаголовков = Новый Структура;
	ПараметрыОтбораЗаголовков.Вставить("ПослеДатыОтправления", ПослеДатыОтправления);
	
	ЗаголовкиПисем = ЗагрузитьЗаголовкиПочтовыхСообщений(Соединение, ПараметрыОтбораЗаголовков);
	
	ВидОперации = "";
	Параметры.Свойство("ВидОперации", ВидОперации);
	ОтметитьЗаголовкиЗагруженныхПисем(ЗаголовкиПисем, ВидОперации, УчетнаяЗапись);
	
	ПараметрыОтбора = Новый Структура("ПисьмоЗагружено", Ложь);
	ЗаголовкиЗагружаемыхПисем = ЗаголовкиПисем.Скопировать(ПараметрыОтбора);
	
	Если ЗаголовкиЗагружаемыхПисем.Количество() > 0 Тогда
		
		ЗаголовкиЗагружаемыхПисем.Сортировать("ДатаОтправления Убыв");
		
		ИдентификаторыПисем = Новый Массив;
		
		Для Каждого ЗаголовокПисьма Из ЗаголовкиЗагружаемыхПисем Цикл
			Если ЗаголовокПисьма.Размер > МаксимальныйРазмерПисьма Тогда
				Продолжить;
			КонецЕсли;
			ИдентификаторыПисем.Добавить(ЗаголовокПисьма.Идентификатор[0]);
		КонецЦикла;
		
		Если ИдентификаторыПисем.Количество() > 0 Тогда
			Письма = ЗагрузитьПочтовыеСообщенияПоИдентификаторам(Соединение, ИдентификаторыПисем);
		КонецЕсли;
		
	КонецЕсли;
	
	Соединение.Отключиться();
	
	// В переопределяемой процедуре при необходимости можно дополнить таблицу значений 
	// данными загруженных в ИБ почтовых сообщений.
	ЗагрузкаПочтовыхСообщенийПереопределяемый.ДополнитьТаблицуПочтовыхСообщений(Письма, ВидОперации, УчетнаяЗапись, ПараметрыОтбораЗаголовков);
	
	Для Каждого Письмо Из Письма Цикл
		Письмо.Идентификатор = Письмо.Идентификатор[0];
	КонецЦикла;
	
	Возврат Письма;
	
КонецФункции

// Возвращает учетную запись настроенную на получения почтовых сообщений или пустую ссылку
// если учетной записи настроенной на получение почты нет.
//
// Возвращаемое значение:
//  СправочникСсылка.УчетныеЗаписиЭлектроннойПочты - учетная запись электронной почты.
//
Функция УчетнаяЗаписьПользователяДляЗагрузкиСообщений() Экспорт

	Возврат ЗагрузкаПочтовыхСообщенийПереопределяемый.УчетнаяЗаписьПользователяДляЗагрузкиСообщений();	
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает таблицу значений для загружаемых почтовых сообщений.
//
// Возвращаемое значение:
//	Таблица значений, содержащая поля:
//		* Вложения 			- Соответствие с полями:
//			** Ключ 		- Строка - Имя файла.
//			** Значение 	- ДвоичныеДанные - Данные файла.
//		* ДатаОтправления 	- ДатаВремя - Дата и время отправления письма.
//		* Идентификатор		- Массив 	- Массив строк с идентификаторами письма.
//		* Размер			- Число 	- Размер почтового сообщения в байтах.
//		* ПисьмоЗагружено 	- Булево	- Истина, если письмо было загружено ранее,
//										  и больше его загружать с сервера не требуется.
//		Остальные поля являются служебными и заполняются только при чтении почты с сервера.
//
Функция СоздатьАдаптированноеОписаниеПисьма(Колонки = Неопределено)
	
	Колонки = Новый Массив;
	Колонки.Добавить("Важность");
	Колонки.Добавить("Вложения");
	Колонки.Добавить("ДатаОтправления");
	Колонки.Добавить("ДатаПолучения");
	Колонки.Добавить("Заголовок");
	Колонки.Добавить("ИмяОтправителя");
	Колонки.Добавить("Идентификатор");
	Колонки.Добавить("Копии");
	Колонки.Добавить("ОбратныйАдрес");
	Колонки.Добавить("Отправитель");
	Колонки.Добавить("Получатели");
	Колонки.Добавить("Размер");
	Колонки.Добавить("Тема");
	Колонки.Добавить("Тексты");
	Колонки.Добавить("Кодировка");
	Колонки.Добавить("СпособКодированияНеASCIIСимволов");
	Колонки.Добавить("Частичное");
	
	Результат = Новый ТаблицаЗначений;
	
	Для Каждого НаименованиеКолонки Из Колонки Цикл
		Результат.Колонки.Добавить(НаименованиеКолонки);
	КонецЦикла;
	
	Результат.Колонки.Добавить("ПисьмоЗагружено", Новый ОписаниеТипов("Булево"));
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьАдаптированныйНаборПисем(Знач НаборПисем)
	
	Результат = СоздатьАдаптированноеОписаниеПисьма();
	
	Для Каждого ПочтовоеСообщение Из НаборПисем Цикл
		НоваяСтрока = Результат.Добавить();
		
		Для Каждого Колонка Из Результат.Колонки Цикл
			
			НаименованиеКолонки = Колонка.Имя;
		
			Если НаименованиеКолонки = "ПисьмоЗагружено" Тогда
				Продолжить;
			КонецЕсли;
		
			Значение = ПочтовоеСообщение[НаименованиеКолонки];
			
			Если ТипЗнч(Значение) = Тип("Строка") Тогда
				Значение = ОбщегоНазначенияКлиентСервер.УдалитьНедопустимыеСимволыXML(Значение);
			КонецЕсли;
			
			Если ТипЗнч(Значение) = Тип("ИнтернетПочтовыеАдреса") Тогда
				ЗначениеИтог = "";
				Для Каждого ОчереднойАдрес  Из Значение Цикл
					ЗначениеВременное =  ОчереднойАдрес.Адрес;
					Если ЗначениеЗаполнено(ОчереднойАдрес.ОтображаемоеИмя) Тогда
						ЗначениеВременное = ОчереднойАдрес.ОтображаемоеИмя + " <" + ЗначениеВременное + ">";
					КонецЕсли;
					Если ЗначениеЗаполнено(ЗначениеВременное) Тогда
						ЗначениеВременное = ЗначениеВременное + "; "
					КонецЕсли;
					ЗначениеИтог = ЗначениеИтог + ЗначениеВременное;
				КонецЦикла;
				
				Если ЗначениеЗаполнено(ЗначениеИтог) Тогда
					ЗначениеИтог = Сред(ЗначениеИтог, 1, СтрДлина(ЗначениеИтог)-2)
				КонецЕсли;
				
				Значение = ЗначениеИтог;
			КонецЕсли;
			
			Если ТипЗнч(Значение) = Тип("ИнтернетПочтовыйАдрес") Тогда
				ЗначениеВременное =  Значение.Адрес;
				Если ЗначениеЗаполнено(Значение.ОтображаемоеИмя) Тогда
					ЗначениеВременное = Значение.ОтображаемоеИмя + " <" + ЗначениеВременное + ">";
				КонецЕсли;
				Значение = ЗначениеВременное;
			КонецЕсли;
			
			Если ТипЗнч(Значение) = Тип("ВажностьИнтернетПочтовогоСообщения") Тогда
				Значение = Строка(Значение);
			КонецЕсли;
			
			Если ТипЗнч(Значение) = Тип("СпособКодированияНеASCIIСимволовИнтернетПочтовогоСообщения") Тогда
				Значение = Строка(Значение);
			КонецЕсли;
			
			Если ТипЗнч(Значение) = Тип("ИнтернетПочтовыеВложения") Тогда
				СоответствиеЗначений = Новый Соответствие;
				
				Для Каждого ОчередноеВложение Из Значение Цикл
					ИмяВложения = ОчередноеВложение.Имя;
					Если ТипЗнч(ОчередноеВложение.Данные) = Тип("ДвоичныеДанные") Тогда
						СоответствиеЗначений.Вставить(ИмяВложения, ОчередноеВложение.Данные);
					Иначе
						ЗаполнитьВложения(СоответствиеЗначений, ИмяВложения, ОчередноеВложение.Данные);
					КонецЕсли;
				КонецЦикла;
				
				Значение = СоответствиеЗначений;
			КонецЕсли;
			
			Если ТипЗнч(Значение) = Тип("ИнтернетТекстыПочтовогоСообщения") Тогда
				МассивЗначений = Новый Массив;
				Для Каждого ОчереднойТекст Из Значение Цикл
					СоответствиеЗначений = Новый Соответствие;
					
					СоответствиеЗначений.Вставить("Данные", ОчереднойТекст.Данные);
					СоответствиеЗначений.Вставить("Кодировка", ОчереднойТекст.Кодировка);
					СоответствиеЗначений.Вставить("Текст", ОбщегоНазначенияКлиентСервер.УдалитьНедопустимыеСимволыXML(ОчереднойТекст.Текст));
					СоответствиеЗначений.Вставить("ТипТекста", Строка(ОчереднойТекст.ТипТекста));
					
					МассивЗначений.Добавить(СоответствиеЗначений);
				КонецЦикла;
				Значение = МассивЗначений;
			КонецЕсли;
			
			НоваяСтрока[НаименованиеКолонки] = Значение;
		КонецЦикла;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Процедура ЗаполнитьВложения(Вложения, ИмяВложения, ИнтернетПочтовоеСообщение)
	
	Для Каждого ИнтернетПочтовоеВложение Из ИнтернетПочтовоеСообщение.Вложения Цикл
		ИмяВложения = ИнтернетПочтовоеВложение.Имя;
		Если ТипЗнч(ИнтернетПочтовоеВложение.Данные) = Тип("ДвоичныеДанные") Тогда
			Вложения.Вставить(ИмяВложения, ИнтернетПочтовоеВложение.Данные);
		Иначе
			ЗаполнитьВложения(Вложения, ИмяВложения, ИнтернетПочтовоеВложение.Данные);
		КонецЕсли;
	КонецЦикла;
	
	Индекс = 0;
	
	Для Каждого ИнтернетТекстыПочтовогоСообщения Из ИнтернетПочтовоеСообщение.Тексты Цикл
		
		Если ИнтернетТекстыПочтовогоСообщения.ТипТекста = ТипТекстаПочтовогоСообщения.HTML Тогда
			Расширение = "html";
		ИначеЕсли ИнтернетТекстыПочтовогоСообщения.ТипТекста = ТипТекстаПочтовогоСообщения.ПростойТекст Тогда
			Расширение = "txt";
		Иначе
			Расширение = "rtf";
		КонецЕсли;
		ИмяТекстаВложения = "";
		Пока ИмяТекстаВложения = "" Или Вложения.Получить(ИмяТекстаВложения) <> Неопределено Цикл
			Индекс = Индекс + 1;
			ИмяТекстаВложения = СтрШаблон("%1 - (%2).%3", ИмяВложения, Индекс, Расширение);
		КонецЦикла;
		Вложения.Вставить(ИмяТекстаВложения, ИнтернетТекстыПочтовогоСообщения.Данные);
	КонецЦикла;
	
КонецПроцедуры

Функция ЗагрузитьЗаголовкиПочтовыхСообщений(Соединение, ПараметрыОтбораЗаголовков)
	
	ЗаголовкиПисем = Соединение.ПолучитьЗаголовки(ПараметрыОтбораЗаголовков);
	ЗаголовкиПисем = ПолучитьАдаптированныйНаборПисем(ЗаголовкиПисем);
	
	Возврат ЗаголовкиПисем;
	
КонецФункции

Функция ЗагрузитьПочтовыеСообщенияПоИдентификаторам(Соединение, ИдентификаторыПисем)
	
	ПочтовыеСообщения = Соединение.Выбрать(Ложь, ИдентификаторыПисем);
	ПочтовыеСообщения = ПолучитьАдаптированныйНаборПисем(ПочтовыеСообщения);
	
	Возврат ПочтовыеСообщения;
	
КонецФункции

Процедура ОтметитьЗаголовкиЗагруженныхПисем(ЗаголовкиПисем, ВидОперации, УчетнаяЗапись)
	
	// В переопределяемой процедуре есть возможность установить у заголовка признак ПисьмоЗагружено = Истина.
	// Почтовые сообщения с признаком ПисьмоЗагружено = Истина не будут загружены с почтового сервера.
	ЗаголовкиОтмечены = ЗагрузкаПочтовыхСообщенийПереопределяемый.ОтметитьЗаголовкиЗагруженныхПисем(ЗаголовкиПисем, ВидОперации, УчетнаяЗапись);
	
КонецПроцедуры

#КонецОбласти