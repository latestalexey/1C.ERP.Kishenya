
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени(
		"Обработка.ПолучениеИВозвратМатериалов.Команда.ПолучениеИВозвратМатериалов");
	
	ОткрытьФорму("Обработка.ПолучениеИВозвратМатериалов.Форма",, 
			ПараметрыВыполненияКоманды.Источник, 
			ПараметрыВыполненияКоманды.Уникальность, 
			ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры
