
#Область СлужебныеПроцедурыИФункции

Процедура ОбновитьИнфонадписьПроцентЕНВД(Форма) Экспорт

	Если Не Форма.ОрганизацияПлательщикЕНВДЗарплатаКадры Тогда
		Возврат;
	КонецЕсли;
	
	Если ПустаяСтрока(Форма.ПроцентЕНВДСтрока) Тогда
		
		Форма.Элементы.ПроцентЕНВДСтрока.ОтображениеПредупрежденияПриРедактировании = ОтображениеПредупрежденияПриРедактировании.НеОтображать;
		ТекстНадписи = НСтр("ru='Введите процент ЕНВД';uk='Введіть відсоток ЕНВД'");
	Иначе
			
		Форма.Элементы.ПроцентЕНВДСтрока.ОтображениеПредупрежденияПриРедактировании = ОтображениеПредупрежденияПриРедактировании.Отображать;
		ТекстНадписи = "";
					
	КонецЕсли;
	Форма.ПроцентЕНВДИнфоНадпись  = ТекстНадписи;
	
КонецПроцедуры

#КонецОбласти
