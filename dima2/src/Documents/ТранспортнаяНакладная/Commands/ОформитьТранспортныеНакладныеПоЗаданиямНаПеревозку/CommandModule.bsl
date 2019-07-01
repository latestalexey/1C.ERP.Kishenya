
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОчиститьСообщения();	
		
	СозданныеТраспортныеНакладные = СоздатьТранспортныеНакладныеНаСервере(ПараметрКоманды);
						
	Если СозданныеТраспортныеНакладные.Количество() = 1 Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Ключ", СозданныеТраспортныеНакладные[0]);
		
		ОткрытьФорму(
				"Документ.ТранспортнаяНакладная.ФормаОбъекта", 
				ПараметрыФормы);
				
	ИначеЕсли СозданныеТраспортныеНакладные.Количество() > 1 Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ТранспортныеНакладные", СозданныеТраспортныеНакладные);
		
		ОткрытьФорму(
				"Документ.ТранспортнаяНакладная.Форма.СозданныеТранспортныеНакладные", 
				ПараметрыФормы);
				
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СоздатьТранспортныеНакладныеНаСервере(ВыделенныеСсылки)
	
	ЗаданияНаПеревозкуДляСозданияТН = Документы.ТранспортнаяНакладная.ПроверитьЗаданияНаПеревозкуДляОформленияТранспортныхНакладных(ВыделенныеСсылки);
	
	СозданныеТраспортныеНакладные = Документы.ТранспортнаяНакладная.СоздатьТранспортныеНакладныеДляЗаданийНаПеревозку(ЗаданияНаПеревозкуДляСозданияТН);
	
	Возврат СозданныеТраспортныеНакладные;
	
КонецФункции

