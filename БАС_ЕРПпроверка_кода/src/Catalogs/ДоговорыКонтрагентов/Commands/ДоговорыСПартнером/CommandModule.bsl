
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("Партнер, Заголовок", ПараметрКоманды, НСтр("ru='Договоры с партнером';uk='Договори з партнером'"));
	
	ОткрытьФорму("Справочник.ДоговорыКонтрагентов.ФормаСписка",
				 ПараметрыФормы,
				 ПараметрыВыполненияКоманды.Источник,
				 ПараметрыВыполненияКоманды.Уникальность,
				 ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры
