#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗаполнитьСписокВыбора();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	СписокВыбранныхЭлементов = Новый СписокЗначений;
	Для каждого ЭлементВыбора Из СписокВыбора Цикл
		Если ЭлементВыбора.Пометка Тогда
			СписокВыбранныхЭлементов.Добавить(ЭлементВыбора.Значение, ЭлементВыбора.Представление);
		КонецЕсли;
	КонецЦикла;
	
	Закрыть(СписокВыбранныхЭлементов);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьСписокВыбора()

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Бригады.Ссылка КАК Значение,
	|	Бригады.Представление КАК Представление
	|ИЗ
	|	Справочник.Бригады КАК Бригады
	|ГДЕ
	|	(&Подразделение = ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка)
	|			ИЛИ Бригады.Подразделение = &Подразделение)
	|	И НЕ Бригады.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	Бригады.Наименование";
	
	Запрос.УстановитьПараметр("Подразделение", Параметры.Отбор.Подразделение);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Пометка = (Параметры.СписокВыбранныхЭлементов.НайтиПоЗначению(Выборка.Значение) <> Неопределено);
		СписокВыбора.Добавить(Выборка.Значение, Выборка.Представление, Пометка);
	КонецЦикла;

КонецПроцедуры

#КонецОбласти
