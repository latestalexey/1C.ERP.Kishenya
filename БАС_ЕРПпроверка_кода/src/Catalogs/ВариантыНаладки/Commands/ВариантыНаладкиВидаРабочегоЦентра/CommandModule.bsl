&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	ПараметрыФормы = Новый Структура("ВидРабочегоЦентра", ПараметрКоманды);
	ОткрытьФорму("Справочник.ВариантыНаладки.Форма.ВариантыНаладки", 
				ПараметрыФормы, 
				ПараметрыВыполненияКоманды.Источник, 
				ПараметрыВыполненияКоманды.Уникальность, 
				ПараметрыВыполненияКоманды.Окно, 
				ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры
