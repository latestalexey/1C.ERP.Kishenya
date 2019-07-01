
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если Параметры.Отбор.Свойство("Договор") Тогда
		
		ДанныеВыбора = Новый СписокЗначений;
		СтандартнаяОбработка = Ложь;
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Договор", Параметры.Отбор.Договор);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ЗНАЧЕНИЕ(Перечисление.ТипыНачисленийПоЛизингу.ВыкупПредметаЛизинга) КАК Ссылка
		|ИЗ
		|	Справочник.ДоговорыЛизинга КАК Т
		|ГДЕ
		|	Т.Ссылка = &Договор
		|	И Т.ЕстьВыкупПредметаЛизинга
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ЗНАЧЕНИЕ(Перечисление.ТипыНачисленийПоЛизингу.ЗачетОбеспечительногоПлатежа)
		|ИЗ
		|	Справочник.ДоговорыЛизинга КАК Т
		|ГДЕ
		|	Т.Ссылка = &Договор
		|	И Т.ЕстьОбеспечительныйПлатеж
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ЗНАЧЕНИЕ(Перечисление.ТипыНачисленийПоЛизингу.АрендныеОбязательства)
		|ИЗ
		|	Справочник.ДоговорыЛизинга КАК Т
		|ГДЕ
		|	Т.Ссылка = &Договор
		|	И Т.ВариантУчетаИмущества = ЗНАЧЕНИЕ(Перечисление.ВариантыУчетаИмуществаПриЛизинге.НаБалансе)";
		
		ДанныеВыбора.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
		ДанныеВыбора.Добавить(Перечисления.ТипыНачисленийПоЛизингу.УслугаПоЛизингу);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти