
#Область СлужебныеПроцедурыИФункции

Функция СообщениеОПредназначенииКомандыОтчет(ТипыОбъектовОтчет) Экспорт
	ТекстСообщения = НСтр("ru='Выбранная команда предназначена для объектов';uk='Обрана команда призначена для об''єктів'") 
		+ ?(ТипыОбъектовОтчет.Количество() = 1, " ", ": " + Символы.ПС);
	Для Каждого Тип Из ТипыОбъектовОтчет Цикл
		ТекстСообщения = ТекстСообщения + Метаданные.НайтиПоТипу(Тип).ПредставлениеСписка + Символы.ПС;
	КонецЦикла;
	Возврат СокрЛП(ТекстСообщения);
КонецФункции

Функция ДоступноПравоПроведения(СписокДокументов) Экспорт
	Возврат МенюОтчеты.ДоступноПравоПроведения(СписокДокументов);
КонецФункции

#КонецОбласти
