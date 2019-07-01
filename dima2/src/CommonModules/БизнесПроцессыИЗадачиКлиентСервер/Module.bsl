
////////////////////////////////////////////////////////////////////////////////
// Подсистема "Бизнес-процессы и задачи".
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обработчики подписок на события.

// Вызывается для добавления полей при получении представления объекта или ссылки бизнес процесса. 
//
Процедура ОбработкаПолученияПолейПредставленияБизнесПроцесса(МенеджерОбъекта, Поля, СтандартнаяОбработка) Экспорт
	
	Поля.Добавить("Наименование");
	Поля.Добавить("Дата");
	СтандартнаяОбработка = Ложь;

КонецПроцедуры

// Вызывается при получении представления объекта или ссылки бизнес процесса. 
//
Процедура ОбработкаПолученияПредставленияБизнесПроцесса(МенеджерОбъекта, Данные, Представление, СтандартнаяОбработка) Экспорт
	
	Наименование = ?(ПустаяСтрока(Данные.Наименование), НСтр("ru='Без описания';uk='Без опису'"), Данные.Наименование);
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ТолстыйКлиентУправляемоеПриложение Или ВнешнееСоединение Тогда
	Дата = Формат(Данные.Дата, ?(ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач"), "ДЛФ=DT", "ДЛФ=D"));
	Представление = Метаданные.НайтиПоТипу(ТипЗнч(МенеджерОбъекта)).Представление();
#Иначе	
	Дата = Формат(Данные.Дата, "ДЛФ=D");
	Представление = НСтр("ru='Бизнес-процесс';uk='Бізнес-процес'");
#КонецЕсли
	ШаблонПредставления = НСтр("ru='%1 от %2 (%3)';uk='%1 від %2 (%3)'");
	Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонПредставления, Наименование, Дата, Представление);
	СтандартнаяОбработка = Ложь;
	 
КонецПроцедуры

#КонецОбласти
