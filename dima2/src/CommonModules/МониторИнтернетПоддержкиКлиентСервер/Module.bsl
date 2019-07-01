
////////////////////////////////////////////////////////////////////////////////
// Подсистема "Монитор Интернет-поддержки".
// ОбщийМодуль.МониторИнтернетПоддержкиКлиентСервер.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Выполняет дополнительную проверку возможности запуска бизнес-процесса
// по точке входа и параметрам создания контекста взаимодействия.
// Вызывается из
// ИнтернетПоддержкаПользователейКлиентСервер.ОпределитьВозможностьЗапускаПоМестуИПараметрам()
//
// Параметры:
//	МестоЗапуска - Строка - точка входа бизнес-процесса.
//	ПараметрыИнтернетПоддержки - см. функцию
//		ИнтернетПоддержкаПользователей.ПараметрыСозданияКонтекста();
//	ОписаниеДействия - Структура - в структуре возвращается описание
//		выполняемого действия в случае запрета запуска бизнес-процесса.
//		см. ИнтернетПоддержкаПользователейКлиентСервер.ОпределитьВозможностьЗапускаПоМестуИПараметрам().
//
Процедура ОпределитьВозможностьЗапуска(МестоЗапуска, ПараметрыИнтернетПоддержки, ОписаниеДействия) Экспорт
	
	ЭтоЗапускПриСтартеПрограммы = ПараметрыИнтернетПоддержки.ПриНачалеРаботыСистемы;
	
	Если НЕ ПараметрыИнтернетПоддержки.ИспользоватьМонитор
		И МестоЗапуска = "handStartNew" Тогда
		
		ОписаниеДействия.Вставить("Действие", "ПоказатьСообщение");
		ОписаниеДействия.Вставить("Сообщение",
			НСтр("ru='Использование монитора Интернет-поддержки
                |недоступно в текущем режиме работы.'
                |;uk='Використання монітора Інтернет-підтримки
                |недоступне в поточному режимі роботи.'"));
		Возврат;
		
	КонецЕсли;
	
	Если ЭтоЗапускПриСтартеПрограммы И НЕ ПараметрыИнтернетПоддержки.ПоказыватьМониторПриНачалеРаботы Тогда
		ОписаниеДействия.Вставить("Действие", "Возврат");
	КонецЕсли;
	
КонецПроцедуры

// Определяет контекст выполнения команды сервиса Интернет-поддержки: клиент
// или сервер платформы.
// Вызывается из ИнтернетПоддержкаПользователейКлиентСервер.ТипКоманды()
//
// Параметры:
//	ИмяКоманды - Строка - имя выполняемой команды;
//	СоединениеНаСервере - Булево - Истина, если соединение с сервисом ИПП
//		устанавливается на сервере платформы.
//	КонтекстВыполнения - Число - в параметре возвращается контекст выполнения
//		команды: 0 - сервер платформы, 1 - клиент, -1 - неизвестная команда.
//
Процедура КонтекстВыполненияКоманды(ИмяКоманды, СоединениеНаСервере, КонтекстВыполнения) Экспорт
	
	Если ИмяКоманды = "check.updatehash" Тогда
		КонтекстВыполнения = 0;
	КонецЕсли;
	
КонецПроцедуры

// Вызывается при структурировании команды сервиса Интернет-поддержки на стороне
// сервера платформы.
// Подробнее см. функцию
// МониторИнтернетПоддержкиКлиентСервер.СтруктурироватьОтветСервера().
//
Процедура СтруктурироватьКомандуСервиса(ИмяКоманды, КомандаСервиса, СтруктураКоманды) Экспорт
	
	Если ИмяКоманды = "check.updatehash" Тогда
		СтруктураКоманды = СтруктурироватьПроверкуХэшаОбновления(КомандаСервиса);
		
	ИначеЕсли ИмяКоманды = "status.set" Тогда
		СтруктураКоманды = СтруктурироватьУстановкуСтатусаИПП(КомандаСервиса);
		
	КонецЕсли;
	
КонецПроцедуры

// Вызывается при необходимости определения параметров формы по ее индексу
// на стороне сервера платформы.
// Вызывается из ИнтернетПоддержкаПользователейКлиентСервер.ПараметрыВнутреннейФормы()
// Параметры:
//	ИндексФормы - Строка - индекс формы бизнес-процесса.
//	Параметры - Структура - параметры формы. В структуру добавляются поля:
//		* ИмяОткрываемойФормы - Строка - полное имя формы по ее индексу,
//			дополнительные параметры открытия формы.
//
Процедура ЗаполнитьПараметрыВнутреннейФормы(ИндексФормы, Параметры) Экспорт
	
	Если ИндексФормы = "100" Тогда
		Параметры.Вставить("ИмяОткрываемойФормы",
			"Обработка.МониторИнтернетПоддержки.Форма.Монитор");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Преобразование команды "Проверить хэш обновления информационного окна" во
// внутреннее представление.
//
Функция СтруктурироватьПроверкуХэшаОбновления(КомандаСервера)
	
	Если КомандаСервера.parameters.parameter.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	СтруктураКоманды = Новый Структура;
	СтруктураКоманды.Вставить("ИмяКоманды"   , "check.updatehash");
	СтруктураКоманды.Вставить("ХэшОбновления", КомандаСервера.parameters.parameter[0].value);
	
	Возврат СтруктураКоманды;
	
КонецФункции

// Преобразование команды "Установить статус" во внутреннее представление.
//
Функция СтруктурироватьУстановкуСтатусаИПП(КомандаСервера)
	
	СтруктураКоманды = Новый Структура;
	
	Если КомандаСервера.parameters.parameter.Количество() = 0 Тогда 
		Возврат Неопределено;
	КонецЕсли;
	
	Для каждого Параметр из КомандаСервера.parameters.parameter Цикл
		
		Если НРег(СокрЛП(Параметр.name)) = "color" Тогда
			СтруктураКоманды.Вставить("Цвет", СокрЛП(Параметр.value));
		КонецЕсли;
		
	КонецЦикла;
	
	СтруктураКоманды.Вставить("ИмяКоманды", КомандаСервера.name);
	
	Возврат СтруктураКоманды;
	
КонецФункции

#КонецОбласти
