
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("", );
	ОткрытьФорму("Обработка.ОперацииЗакрытияМесяца.Форма",
				 ПараметрыФормы,
				 ПараметрыВыполненияКоманды.Источник,
				 ПараметрыВыполненияКоманды.Уникальность,
				 ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры
