
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ДанныеФайла = ПолучитьДанныеПрисоединенногоФайлаПакетаНаСервере(ПараметрКоманды, ПараметрыВыполненияКоманды.Источник.УникальныйИдентификатор);
		
	ПолучитьФайл(ДанныеФайла.СсылкаНаДвоичныеДанныеФайла, ДанныеФайла.ИмяФайла);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьДанныеПрисоединенногоФайлаПакетаНаСервере(Знач ПакетЭД, Знач УникальныйИдентификатор)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЭДПрисоединенныеФайлы.Ссылка
	|ИЗ
	|	Справочник.ЭДПрисоединенныеФайлы КАК ЭДПрисоединенныеФайлы
	|ГДЕ
	|	ЭДПрисоединенныеФайлы.ВладелецФайла = &ВладелецФайла";
	
	Запрос.УстановитьПараметр("ВладелецФайла", ПакетЭД);
	
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	РезультатЗапроса.Следующий();
	
	ДанныеФайла = ОбменСКонтрагентамиСлужебныйВызовСервера.ПолучитьДанныеФайла(РезультатЗапроса.Ссылка,
		УникальныйИдентификатор);
		
	Возврат ДанныеФайла;
	
КонецФункции

#КонецОбласти
