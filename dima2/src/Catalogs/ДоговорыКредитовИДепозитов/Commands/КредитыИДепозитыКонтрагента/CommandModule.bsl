
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("Контрагент, Заголовок", ПараметрКоманды, НСтр("ru='Кредиты и депозиты контрагента';uk='Кредити та депозити контрагента'"));
	
	ОткрытьФорму("Справочник.ДоговорыКредитовИДепозитов.ФормаСписка",
				 ПараметрыФормы,
				 ПараметрыВыполненияКоманды.Источник,
				 ПараметрыВыполненияКоманды.Уникальность,
				 ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры
