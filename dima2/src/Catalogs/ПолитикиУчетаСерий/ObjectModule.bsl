#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если Не УказыватьПриОтгрузке
		И Не УказыватьПриПриемке
		И Не УказыватьПриПеремещенииМеждуПомещениями
		И Не УказыватьПриОтраженииИзлишков
		И Не УказыватьПриОтраженииНедостач
		И Не УказыватьПриДвиженииМатериалов
		И Не УказыватьПриДвиженииПродукции Тогда
		
		ТекстСообщения = НСтр("ru='Необходимо указать хотя бы одну операцию, требующую указания серий.';uk='Необхідно вказати хоча б одну операцію, що потребує зазначення серій.'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,,Отказ);
		
	КонецЕсли;
	
	Если УказыватьПриОтгрузке
		И Не УказыватьПриОтгрузкеПоПеремещению
		И Не УказыватьПриОтгрузкеПоВозвратуПоставщику
		И Не УказыватьПриОтгрузкеКлиенту
		И Не УказыватьПриОтгрузкеВРозницу
		И Не УказыватьПриОтгрузкеКомплектующихДляСборки
		И Не УказыватьПриОтгрузкеНаВнутренниеНужды 
		И Не УказыватьПриОтгрузкеКомплектовДляРазборки Тогда
		
		ТекстСообщения = НСтр("ru='Включена политика указания серий при отгрузке, но не выбрано ни одной операции отгрузки, когда необходимо указывать серии';uk='Включена політика зазначення серій при відвантаженні, але не вибрано жодної операції відвантаження, коли необхідно зазначати серії'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,"УказыватьПриОтгрузке","Объект",Отказ);
		
	КонецЕсли;
	
	Если УказыватьПриПриемке
		И Не УказыватьПриПриемкеОтПоставщика 
		И Не УказыватьПриПриемкеПоВозвратуОтКлиента 
		И Не УказыватьПриПриемкеСобранныхКомплектов 
		И Не УказыватьПриПриемкеПоПеремещению 
		И Не УказыватьПриПриемкеПоПрочемуОприходованию 
		И Не УказыватьПриПриемкеКомплектующихПослеРазборки
		И Не УказыватьПриВозвратеНепринятыхПолучателемТоваров
		И Не УказыватьПриПриемкеПродукцииИзПроизводства Тогда
		
		ТекстСообщения = НСтр("ru='Включена политика указания серий при приемке, но не выбрано ни одной операции приемки, когда необходимо указывать серии';uk='Включена політика зазначення серій при прийманні, але не вибрано жодної операції приймання, коли необхідно зазначати серії'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,"УказыватьПриПриемке","Объект",Отказ);
		
	КонецЕсли;
	
	Если УказыватьПриОтгрузке
		И Не УказыватьПриПланированииОтгрузки
		И Не УказыватьПоФактуОтбора 
		И Не УказыватьПриПланированииОтбора Тогда
		
		ТекстСообщения = НСтр("ru='Не выбран вариант указания серий при отгрузке';uk='Не вибрано варіант вказівки серій при відвантаженні'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,"УказыватьПриОтгрузке","Объект",Отказ);
		
	КонецЕсли;
	
	//++ НЕ УТ
	Если УказыватьПриДвиженииМатериалов
		И НЕ УказыватьПриПолученииМатериалов 
		И НЕ УказыватьПриВозвратеНаСклад 
		И НЕ УказыватьДляМатериаловПриВыполненииМаршрутныхЛистов 
		И НЕ УказыватьПриОтраженииЗатратНаПроизводство Тогда
		
		ТекстСообщения = НСтр("ru='Включена политика указания серий при движении материалов, но не выбрано ни одной операции, когда необходимо указывать серии';uk='Включена політика зазначення серій при русі матеріалів, але не вибрано жодної операції, коли необхідно зазначати серії'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "УказыватьПриДвиженииМатериалов", "Объект", Отказ);
	КонецЕсли; 
	
	Если УказыватьПриДвиженииПродукции
		И НЕ УказыватьДляИзделийПриВыполненииМаршрутныхЛистов 
		И НЕ УказыватьПриВыпускеВПодразделение Тогда
		
		ТекстСообщения = НСтр("ru='Включена политика указания серий при движении продукции, но не выбрано ни одной операции, когда необходимо указывать серии';uk='Включена політика зазначення серій при русі продукції, але не вибрано жодної операції, коли необхідно зазначати серії'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "УказыватьПриДвиженииПродукции", "Объект", Отказ);
	КонецЕсли; 
	//-- НЕ УТ
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если Не УказыватьПриОтгрузке Тогда
		УказыватьПоФактуОтбора           = Ложь;
		УказыватьПриПланированииОтбора   = Ложь;
		УказыватьПриПланированииОтгрузки = Ложь;
	КонецЕсли;
	
	ДляСклада = УказыватьПриПриемке
				ИЛИ УказыватьПриПересчетеТоваров
				ИЛИ УказыватьПриОтгрузке
				ИЛИ УказыватьПриОтраженииИзлишков
				ИЛИ УказыватьПриОтраженииНедостач
				ИЛИ УказыватьПриПеремещенииМеждуПомещениями;
		
	ДляПроизводства = УказыватьПриДвиженииМатериалов
		ИЛИ УказыватьПриДвиженииПродукции;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли