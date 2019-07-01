#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	МетаданныеОбъекта = Метаданные();
	
	Для Каждого СтрМас Из ЭтотОбъект Цикл
		СтрМас.ГлубинаАнализа                     = МетаданныеОбъекта.Ресурсы.ГлубинаАнализа.ЗначениеЗаполнения;
		СтрМас.МинимальнаяВероятностьОтгрузки     = МетаданныеОбъекта.Ресурсы.МинимальнаяВероятностьОтгрузки.ЗначениеЗаполнения;
		СтрМас.УровеньОбслуживанияУпаковокКлассаX = МетаданныеОбъекта.Ресурсы.УровеньОбслуживанияУпаковокКлассаX.ЗначениеЗаполнения;
		СтрМас.УровеньОбслуживанияУпаковокКлассаZ = МетаданныеОбъекта.Ресурсы.УровеньОбслуживанияУпаковокКлассаZ.ЗначениеЗаполнения;
		СтрМас.ИспользоватьПодпитку               = МетаданныеОбъекта.Ресурсы.ИспользоватьПодпитку.ЗначениеЗаполнения;
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	ТекущийОбъект = ЭтотОбъект[0];
	
	МассивНепроверяемыхРеквизитов.Добавить("РабочийУчастокОтбор");
	МассивНепроверяемыхРеквизитов.Добавить("ОграничениеПоВесуОтбор");
	МассивНепроверяемыхРеквизитов.Добавить("ОграничениеПоОбъемуОтбор");
	МассивНепроверяемыхРеквизитов.Добавить("РабочийУчастокПодпитка");
   	МассивНепроверяемыхРеквизитов.Добавить("ОграничениеПоВесуПодпитка");
	МассивНепроверяемыхРеквизитов.Добавить("ОграничениеПоОбъемуПодпитка");
			
	Если ТекущийОбъект.НастройкаФормированияПоРабочимУчасткамОтбор = "ПоОдномуРабочемуУчастку" 
		И Не ЗначениеЗаполнено(ТекущийОбъект.РабочийУчастокОтбор) Тогда
		
		ТекстСообщения = НСтр("ru='Поле ""Рабочий участок"" для создания заданий на отбор не заполнено.';uk='Поле ""Робоча ділянка"" для створення завдань на відбір не заповнено.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "РабочийУчастокОтбор", "Запись", Отказ);
		
	КонецЕсли;
	
	Если ТекущийОбъект.ОграничиватьПоВесуОтбор
		И Не ЗначениеЗаполнено(ТекущийОбъект.ОграничениеПоВесуОтбор)
		И (Не ТекущийОбъект.НастройкаФормированияПоРабочимУчасткамОтбор = "СРазбиениемПоРабочимУчасткам") Тогда
		
		ТекстСообщения = НСтр("ru='Поле ""Ограничение по весу"" для создания заданий на отбор не заполнено.';uk='Поле ""Обмеження за вагою"" для створення завдань на відбір не заповнено.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "ОграничениеПоВесу", "Запись", Отказ);
		
	КонецЕсли;
	
	Если ТекущийОбъект.ОграничиватьПоОбъемуОтбор
		И Не ЗначениеЗаполнено(ТекущийОбъект.ОграничениеПоОбъемуОтбор)
		И (Не ТекущийОбъект.НастройкаФормированияПоРабочимУчасткамОтбор = "СРазбиениемПоРабочимУчасткам") Тогда
		
		ТекстСообщения = НСтр("ru='Поле ""Ограничение по объему"" для создания заданий на отбор не заполнено.';uk='Поле ""Обмеження за об''ємом"" для створення завдань на відбір не заповнено.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "ОграничениеПоОбъему", "Запись", Отказ);
		
	КонецЕсли;
	
	Если ТекущийОбъект.НастройкаФормированияПоРабочимУчасткамПодпитка = "ПоОдномуРабочемуУчастку" 
		И Не ЗначениеЗаполнено(ТекущийОбъект.РабочийУчастокПодпитка) Тогда
		
		ТекстСообщения = НСтр("ru='Поле ""Рабочий участок"" для создания заданий на подпитку не заполнено.';uk='Поле ""Робоча ділянка"" для створення завдань на підживлення не заповнено.'");	
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "РабочийУчастокПодпитка", "Запись", Отказ);
		
	КонецЕсли;
		
	Если ТекущийОбъект.ОграничиватьПоВесуПодпитка
		И Не ЗначениеЗаполнено(ТекущийОбъект.ОграничениеПоВесуПодпитка)
		И (Не ТекущийОбъект.НастройкаФормированияПоРабочимУчасткамПодпитка = "СРазбиениемПоРабочимУчасткам") Тогда
		
		ТекстСообщения = НСтр("ru='Поле ""Ограничение по весу"" для создания заданий на подпитку не заполнено.';uk='Поле ""Обмеження за вагою"" для створення завдань на підживлення не заповнено.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "ОграничениеПоВесуПодпитка", "Запись", Отказ);
	
	КонецЕсли;
	
	Если ТекущийОбъект.ОграничиватьПоОбъемуПодпитка
		И Не ЗначениеЗаполнено(ТекущийОбъект.ОграничениеПоОбъемуПодпитка)
		И (Не ТекущийОбъект.НастройкаФормированияПоРабочимУчасткамПодпитка = "СРазбиениемПоРабочимУчасткам") Тогда
		
		ТекстСообщения = НСтр("ru='Поле ""Ограничение по объему"" для создания заданий на подпитку не заполнено.';uk='Поле ""Обмеження за об''ємом"" для створення завдань на підживлення не заповнено.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "ОграничениеПоОбъемуПодпитка", "Запись", Отказ);
		
	КонецЕсли;
		
 	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры
	
#КонецОбласти
#КонецЕсли