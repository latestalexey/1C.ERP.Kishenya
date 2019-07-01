#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область БлокФункцийПервоначальногоЗаполненияИОбновленияИБ

Процедура СоздатьТарифыПоНастройкам(НастройкиРасчетаЗарплаты = Неопределено) Экспорт
	
	Если НастройкиРасчетаЗарплаты = Неопределено Тогда
		НастройкиРасчетаЗарплаты = РасчетЗарплатыРасширенный.НастройкиРасчетаЗарплаты();
	КонецЕсли;
	
	// Исполнительные документы
	Если Не НастройкиРасчетаЗарплаты.ИспользоватьИсполнительныеЛисты Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА КАК Поле1
	|ИЗ
	|	Справочник.ТарифыПлатежныхАгентов КАК ТарифыПлатежныхАгентов";
	
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	// Укрпошта
	Тариф = Справочники.ТарифыПлатежныхАгентов.СоздатьЭлемент();
	Тариф.Наименование = НСтр("ru='Укрпошта';uk='Укрпошта'");

	Тариф.ИспользуетсяШкала = Истина;
	
	СтрокаШкалы = Тариф.Шкала.Добавить();
	СтрокаШкалы.Порог = 2000;
	СтрокаШкалы.Процент = 2;
	СтрокаШкалы.МинимальнаяСумма = 10;
	
	СтрокаШкалы = Тариф.Шкала.Добавить();
	СтрокаШкалы.Порог = 500000;
	СтрокаШкалы.Процент = 1;
	СтрокаШкалы.МинимальнаяСумма = 10;
	
	Тариф.Записать();
	
	Тариф = Справочники.ТарифыПлатежныхАгентов.СоздатьЭлемент();
	Тариф.Наименование = НСтр("ru='Укрпошта (срочный)';uk='Укрпошта (терміновий)'");

	СтрокаШкалы = Тариф.Шкала.Добавить();
	СтрокаШкалы.Процент = 1;
	СтрокаШкалы.МинимальнаяСумма = 10;
	
	Тариф.Записать();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли