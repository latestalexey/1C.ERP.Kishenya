
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	ПараметрыФормы = Новый Структура(
			"Отбор, КлючНастроек, СформироватьПриОткрытии",
			Новый Структура("Сделка", ПараметрКоманды),
			"Сделка",
			Истина);

	ОткрытьФорму("Обработка.ДокументыПоПартнеруИСделке.Форма.ДокументыПоСделке",
			ПараметрыФормы,
			ПараметрыВыполненияКоманды.Источник,
			ПараметрыВыполненияКоманды.Уникальность,
			ПараметрыВыполненияКоманды.Окно);

КонецПроцедуры
