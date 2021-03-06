
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Запись, ЭтотОбъект);

	ДоступныеСчетаУчетаРасходов();
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПроизводствоНаСтороне") Тогда
		Элементы.Подразделение.Заголовок = НСтр("ru='Подразделение / Переработчик';uk='Підрозділ / Переробник'");
	Иначе
		Элементы.Подразделение.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.СтруктураПредприятия");
		Элементы.Подразделение.ВыбиратьТип = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ПорядокОтраженияРасходов");
	
КонецПроцедуры // ПослеЗаписи()

&НаКлиенте
Процедура СтатьяРасходовПриИзменении(Элемент)
	
	СтатьяРасходовПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура СтатьяРасходовПриИзмененииНаСервере()
	
	ДоступныеСчетаУчетаРасходов();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервере
Процедура ДоступныеСчетаУчетаРасходов()
	
	СтруктураСчетовУчета = Обработки.НастройкаОтраженияДокументовВРеглУчете.ДоступныеСчетаУчетаРасходов(Запись.СтатьяРасходов);
	
	ПараметрыВыбора = Новый Массив;
	ПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", Новый ФиксированныйМассив(СтруктураСчетовУчета.СчетаРасходов)));
	Элементы.СчетУчета.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбора);
	
	Если СтруктураСчетовУчета.СчетаРасходов.Найти(Запись.СчетУчета) = Неопределено Тогда
		Запись.СчетУчета = ПланыСчетов.Хозрасчетный.ПустаяСсылка();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
