#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	КоличествоЭтапов = Интервалы.Количество();
	
	Если КоличествоЭтапов < 2 Тогда
		Возврат;
	КонецЕсли;
	
	Для ВнешнийСчетчик = 2 По КоличествоЭтапов Цикл
	
		ИндексПредыдущегоЭтапа  = ВнешнийСчетчик - 2;
		ИндексТекущегоЭтапа     = ВнешнийСчетчик - 1;
		ПредыдущееЗначениеСрока = Интервалы[ИндексПредыдущегоЭтапа].НижняяГраницаИнтервала;
		ТекущееЗначениеСрока    = Интервалы[ИндексТекущегоЭтапа].НижняяГраницаИнтервала;
		
		// Значение поля НижняяГраницаИнтервала табличной части Интервалы
		// должно идти по возрастанию. Это необходимо для того, чтобы
		// дебиторская задолженность могла быть отнесена только к одному этапу
		Если ТекущееЗначениеСрока <= ПредыдущееЗначениеСрока Тогда
			
			ТекстОшибки = НСтр("ru='Нижняя граница в строке %ИндексТекущегоЭтапа%
            | должна быть больше, чем в строке %ИндексПредыдущегоЭтапа%'
            |;uk='Нижня межа в рядку %ИндексТекущегоЭтапа%
            |повинна бути більше, ніж у рядку %ИндексПредыдущегоЭтапа%'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки,"%ИндексТекущегоЭтапа%",ИндексТекущегоЭтапа + 1);
			ТекстОшибки = СтрЗаменить(ТекстОшибки,"%ИндексПредыдущегоЭтапа%",ИндексПредыдущегоЭтапа + 1);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Интервалы",ИндексТекущегоЭтапа+1,"НижняяГраницаИнтервала"),
				,
				Отказ);
			
		КонецЕсли;
			
	КонецЦикла;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	// Дозаполним скрытый реквизит "ВерхняяГраницаИнтервала"
	
	КоличествоИнтервалов       = Интервалы.Количество();
	НаименованиеИнтервалаСвыше = НСтр("ru='Свыше %НижняяГраницаИнтервала% дней';uk='Понад %НижняяГраницаИнтервала% днів'");
	НаименованиеИнтервалаОтДо  = НСтр("ru='От %НижняяГраницаИнтервала% до %ВерхняяГраницаИнтервала%%ДняДней%';uk='Від %НижняяГраницаИнтервала% до %ВерхняяГраницаИнтервала%%ДняДней%'");
	ВерхняяГраницаИнтервала    = 9999999999;
	
	Если Интервалы.Количество() = 1 Тогда
		
		Интервалы[0].ВерхняяГраницаИнтервала = ВерхняяГраницаИнтервала;
		Интервалы[0].НаименованиеИнтервала = СтрЗаменить(НаименованиеИнтервалаСвыше, "%НижняяГраницаИнтервала%", Интервалы[0].НижняяГраницаИнтервала);
		
	ИначеЕсли КоличествоИнтервалов > 1 Тогда
		
		Для ТекИндекс = 1 По КоличествоИнтервалов-1 Цикл
			
			ПредыдущийЭтап = Интервалы[ТекИндекс-1];
			
			Если ТекИндекс < КоличествоИнтервалов Тогда
				
				ПредыдущийЭтап.ВерхняяГраницаИнтервала = Интервалы[ТекИндекс].НижняяГраницаИнтервала-1;
				НаименованиеИнтервалаОтДоПредставление = СтрЗаменить(НаименованиеИнтервалаОтДо, "%НижняяГраницаИнтервала%", ПредыдущийЭтап.НижняяГраницаИнтервала);
				НаименованиеИнтервалаОтДоПредставление = СтрЗаменить(НаименованиеИнтервалаОтДоПредставление, "%ВерхняяГраницаИнтервала%", ПредыдущийЭтап.ВерхняяГраницаИнтервала);
				НаименованиеИнтервалаОтДоПредставление = СтрЗаменить(НаименованиеИнтервалаОтДоПредставление, "%ДняДней%", ?(ПредыдущийЭтап.ВерхняяГраницаИнтервала = 1,НСтр("ru=' дня';uk=' дня'"),НСтр("ru=' дней';uk=' днів'")));
				ПредыдущийЭтап.НаименованиеИнтервала = НаименованиеИнтервалаОтДоПредставление;
				
			КонецЕсли;
			
			Интервалы[КоличествоИнтервалов-1].ВерхняяГраницаИнтервала = ВерхняяГраницаИнтервала;
			Интервалы[КоличествоИнтервалов-1].НаименованиеИнтервала = СтрЗаменить(НаименованиеИнтервалаСвыше, "%НижняяГраницаИнтервала%", Интервалы[КоличествоИнтервалов-1].НижняяГраницаИнтервала);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
