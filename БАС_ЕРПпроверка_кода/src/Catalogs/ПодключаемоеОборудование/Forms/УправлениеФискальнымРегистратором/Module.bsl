
#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	МенеджерОборудованияВызовСервераПереопределяемый.УстановитьОтображениеЗаголовковГрупп(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПечатьФискальногоОтчетаЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	ЭтотОбъект.Доступность = Истина;
	
	Если РезультатВыполнения.Результат Тогда
		ТекстСообщения = НСтр("ru='Печать фискального отчета завершена.';uk='Друк фіскального звіту завершений.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьОтчетаБезГашенияВыполнить()
	
	ЭтотОбъект.Доступность = Ложь;
	
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("ПечатьФискальногоОтчетаЗавершение", ЭтотОбъект);
	МенеджерОборудованияКлиент.НачатьПечатьФискальногоОтчета(ОповещениеПриЗавершении, УникальныйИдентификатор, Неопределено, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьОтчетаСГашениемВыполнить()
	
	ЭтотОбъект.Доступность = Ложь;
	
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("ПечатьФискальногоОтчетаЗавершение", ЭтотОбъект);
	МенеджерОборудованияКлиент.НачатьПечатьФискальногоОтчета(ОповещениеПриЗавершении, УникальныйИдентификатор, Неопределено, Истина);
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ПечатьОтчетаОПроданныхТоварахВыполнить()
	
	ЭтотОбъект.Доступность = Ложь;
	
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("ПечатьФискальногоОтчетаЗавершение", ЭтотОбъект);
	МенеджерОборудованияКлиент.НачатьПечатьДополнительногоФискальногоОтчета(ОповещениеПриЗавершении, УникальныйИдентификатор, Неопределено, "PrintSoldReport");
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьПериодическогоОтчетаПоДатамВыполнить()
	
	Если НЕ ЗначениеЗаполнено(ПериодПериодическогоОтчета) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Заполните период за который хотите сформировать отчет.';uk='Заповніть період за який необхідно сформувати звіт.'"));
		Возврат;
	КонецЕсли;
	
	ВходныеПараметры  = Новый Массив;
	
	ВходныеПараметры.Добавить(ПериодПериодическогоОтчета.ДатаНачала);
	ВходныеПараметры.Добавить(ПериодПериодическогоОтчета.ДатаОкончания);
	
	ЭтотОбъект.Доступность = Ложь;
	
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("ПечатьФискальногоОтчетаЗавершение", ЭтотОбъект);
	МенеджерОборудованияКлиент.НачатьПечатьДополнительногоФискальногоОтчета(ОповещениеПриЗавершении, УникальныйИдентификатор, Неопределено, "PrintPReportDate", ВходныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьПериодическогоОтчетаПоНомерамВыполнить()
	
	Если НЕ ЗначениеЗаполнено(НачальныйНомерПериодическогоОтчета) ИЛИ НЕ ЗначениеЗаполнено(КонечныйНомерПериодическогоОтчета) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Заполните номера дневных отчетов для формирования отчета.';uk='Заповніть номери денних звітів для формування звіту.'"));
		Возврат;
	КонецЕсли;
	
	ВходныеПараметры  = Новый Массив;
	
	ВходныеПараметры.Добавить(НачальныйНомерПериодическогоОтчета);
	ВходныеПараметры.Добавить(КонечныйНомерПериодическогоОтчета);
	
	ЭтотОбъект.Доступность = Ложь;
	
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("ПечатьФискальногоОтчетаЗавершение", ЭтотОбъект);
	МенеджерОборудованияКлиент.НачатьПечатьДополнительногоФискальногоОтчета(ОповещениеПриЗавершении, УникальныйИдентификатор, Неопределено, "PrintPReportNumber", ВходныеПараметры);
	
КонецПроцедуры
