#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Наименование") Тогда
		//создание из взаимодействия по описанию участника
			Наименование = ДанныеЗаполнения.Наименование;
		ИначеЕсли ДанныеЗаполнения.Свойство("Описание") Тогда
			Наименование = ДанныеЗаполнения.Описание;
		КонецЕсли;
		Если ДанныеЗаполнения.Свойство("Владелец") Тогда
			Владелец = ДанныеЗаполнения.Владелец;
		КонецЕсли
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Партнеры") Тогда
		Владелец = ДанныеЗаполнения;
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.ФизическиеЛица") Тогда
		ФизЛицо = ДанныеЗаполнения;
	КонецЕсли;
	
	//уточнить автора информации
	Если НЕ ЗначениеЗаполнено(Автор) Тогда
		Автор = Пользователи.АвторизованныйПользователь();
	КонецЕсли;
	
	//уточнить дату регистрации связи
	Если НЕ ЗначениеЗаполнено(ДатаРегистрацииСвязи) Тогда
		ДатаРегистрацииСвязи = ТекущаяДата();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли