
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОбъектОтбора = ПараметрКоманды;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ОбъектОтбора", ОбъектОтбора);
		
	ОткрытьФорму("Обработка.ФормированиеПлатежныхДокументовПоНалогам.Форма", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник); 

	
КонецПроцедуры
