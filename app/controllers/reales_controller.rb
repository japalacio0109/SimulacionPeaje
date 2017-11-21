class RealesController < ApplicationController
  before_action :validation, only: [:calculate]

  def index

  end

  def calculate
    hora1 = form_params[:hini].split(":")
    hora2 = form_params[:hfini].split(":")
    med_llegada = form_params[:med_llegada].to_i


    minutos1 = (hora1[0].to_i * 60) + hora1[1].to_i
    minutos2 = (hora2[0].to_i * 60) + hora2[1].to_i
    resta = (minutos1 - minutos2).abs * 60

    @T = resta


    # render json: {hora1: hora1, hora2: hora2}
    # render json: {hora1: minutos1, hora2: minutos2, resta: resta}
    @a_aleatorios = []
    a_anterior = []
    @a_result = []
    tiempo = 0.00000
    suceso = "-"

    # Tiempo de Llegada siguiente vehiculo
    siguiente = siguiente_llegada(med_llegada)
    sgt_tmp = tiempo + siguiente[0][0]

    # Tipo de vehículo siguiente en llegar
    sgt_tip = siguiente[0][1]

    # Número de vehículos en cola
    # Caseta Especial
    num_esp = rand(0..4).to_i

    # Caseta General 1
    num_gral1 = rand(0..4).to_i

    # Caseta General 2
    num_gral2 = rand(0..4).to_i

    @esp = num_esp
    @gral1 = num_gral1
    @gral2 = num_gral2


    # Estado de la caseta
    # -----------------------------------------------------------------
    # Caseta Especial
    # -----------------------------------------------------------------
    caseta = estado_caseta(num_esp,0)
    # Estado
    est_esp = caseta[0][0]

    # Tiempo de Servicio
    est_tmp_esp = caseta[0][1]

    # -----------------------------------------------------------------
    # Caseta General 1
    # -----------------------------------------------------------------
    caseta = estado_caseta(num_gral1,1)
    # Estado
    est_gral1 = caseta[0][0]

    # Tiempo de Servicio
    est_tmp_gral1 = caseta[0][1]

    # -----------------------------------------------------------------
    # Caseta General 2
    # -----------------------------------------------------------------
    caseta = estado_caseta(num_gral2,1)
    # Estado
    est_gral2 = caseta[0][0]

    # Tiempo de Servicio
    est_tmp_gral2 = caseta[0][1]
    # -----------------------------------------------------------------


    a_anterior = [
                  tiempo,
                  suceso,
                  est_esp,
                  est_tmp_esp,
                  est_gral1,
                  est_tmp_gral1,
                  est_gral2,
                  est_tmp_gral2,
                  num_esp,
                  num_gral1,
                  num_gral2,
                  sgt_tmp,
                  sgt_tip
                ]
    @a_result << a_anterior
    a_actual = a_anterior
    while(a_anterior[11] < resta) do

      menor = a_anterior[11]

      if a_anterior[2] == 1
        if a_anterior[3] < menor
          menor = a_anterior[3]
        end
      end
      if a_anterior[4] == 1
        if a_anterior[5] < menor
          menor = a_anterior[5]
        end
      end
      if a_anterior[6] == 1
        if a_anterior[7] < menor
          menor = a_anterior[7]
        end
      end
      if menor == a_anterior[11]
        # Llegada
        suceso = 1
        siguiente = siguiente_llegada(med_llegada)
        tiempo = menor
        sgt_tmp = (tiempo + siguiente[0][0]).truncate(5)
        sgt_tip = siguiente[0][1]
      else
        # Salida
        tiempo = menor
        sgt_tmp = a_anterior[11]
        sgt_tip = a_anterior[12]
        suceso = 0
      end

      if suceso == 1
        # tiempo = a_anterior[11]

        if a_anterior[12] == 0
          if a_anterior[8] < a_anterior[9] and a_anterior[8] < a_anterior[10]
            num_esp = a_anterior[8] + 1
            num_gral1 = a_anterior[9]
            num_gral2 = a_anterior[10]

            @esp = @esp + 1

          elsif a_anterior[9] < a_anterior[8] and a_anterior[9] < a_anterior[10]
            num_esp = a_anterior[8]
            num_gral1 = a_anterior[9] + 1
            num_gral2 = a_anterior[10]

            @gral1 = @gral1 + 1

          elsif a_anterior[10] < a_anterior[8] and a_anterior[10] < a_anterior[9]
            num_esp = a_anterior[8]
            num_gral1 = a_anterior[9]
            num_gral2 = a_anterior[10] + 1

            @gral2 = @gral2 + 1

          else
            num_esp = a_anterior[8]
            num_gral1 = a_anterior[9] + 1
            num_gral2 = a_anterior[10]

            @gral1 = @gral1 + 1


          end
        else
          if a_anterior[9] < a_anterior[10]
            num_esp = a_anterior[8]
            num_gral1 = a_anterior[9] + 1
            num_gral2 = a_anterior[10]
            @gral1 = @gral1 + 1

          else
            num_esp = a_anterior[8]
            num_gral1 = a_anterior[9]
            num_gral2 = a_anterior[10] + 1
            @gral2 = @gral2 + 1

          end
        end

      else
        if menor == est_tmp_esp
          num_esp = a_anterior[8] - 1
          num_gral1 = a_anterior[9]
          num_gral2 = a_anterior[10]
          @esp = @esp - 1

        else
          if menor == est_tmp_gral1
            num_esp = a_anterior[8]
            num_gral1 = a_anterior[9] - 1
            num_gral2 = a_anterior[10]
            @gral1 = @gral1 - 1
          else
            if menor == est_tmp_gral2
              num_esp = a_anterior[8]
              num_gral1 = a_anterior[9]
              num_gral2 = a_anterior[10] - 1
              @gral2 = @gral2 - 1

            end
          end
        end




      end

      caseta = estado_caseta(num_esp,0)
      est_esp = caseta[0][0]
      if num_esp > 0
        if a_anterior[8] <= num_esp and a_anterior[8] > 0
          est_tmp_esp = (a_anterior[3]).truncate(5)

        else
          est_tmp_esp = (caseta[0][1] + tiempo).truncate(5)
        end
      else
        est_tmp_esp = 0
      end

      caseta = estado_caseta(num_gral1,1)
      est_gral1 = caseta[0][0]
      if num_gral1 > 0
        if a_anterior[9] <= num_gral1 and a_anterior[9] > 0
          est_tmp_gral1 = (a_anterior[5]).truncate(5)

        else
          est_tmp_gral1 = (caseta[0][1] + tiempo).truncate(5)
        end
      else
        est_tmp_gral1 = 0
      end

      caseta = estado_caseta(num_gral2,1)
      est_gral2 = caseta[0][0]
      if num_gral2 > 0
        if a_anterior[10] <= num_gral2 and a_anterior[10] > 0
          est_tmp_gral2 = (a_anterior[7]).truncate(5)

        else
          est_tmp_gral2 = (caseta[0][1] + tiempo).truncate(5)
        end
      else
        est_tmp_gral2 = 0
      end


      a_actual = []
      a_actual = [
                    tiempo,
                    suceso,
                    est_esp,
                    est_tmp_esp,
                    est_gral1,
                    est_tmp_gral1,
                    est_gral2,
                    est_tmp_gral2,
                    num_esp,
                    num_gral1,
                    num_gral2,
                    sgt_tmp,
                    sgt_tip
                  ]
      a_anterior = []
      a_anterior = a_actual
      @a_result << a_actual
    end
    arr_esp = []
    arr_gral1 = []
    arr_gral2 = []

    @a_result.each do |row|
      if row[3] > 0
        arr_esp << row[3]
      end

      if row[5] > 0
        arr_gral1 << row[5]

      end

      if row[7] > 0
        arr_gral2 << row[7]
      end

    end
    @cont_esp = arr_esp.uniq.count
    @cont_gral1 = arr_gral1.uniq.count
    @cont_gral2 = arr_gral2.uniq.count

    cont_gen = @a_result.count - 1


    intervalos_especiales = []
    intervalos_general1 = []
    intervalos_general2 = []
    inicio = 0
    (0..cont_gen).each do |n|
      actu = @a_result[n]

      if @a_result[n + 1] != nil
        sig = @a_result[n + 1]
      else
        sig = actu
      end

      if actu[0] == 0
        inicio = 0.000
      end
      val_ant = actu[8]
      val_sgt = sig[8]

      if val_ant == val_sgt
        val = val_sgt
      else
        val = val_ant
        fin = sig[0]
        intervalos_especiales << [inicio,fin,val]
        inicio = intervalos_especiales.last[1]
      end

    end

    inicio = 0
    (0..cont_gen).each do |n|
      actu = @a_result[n]

      if @a_result[n + 1] != nil
        sig = @a_result[n + 1]
      else
        sig = actu
      end

      if actu[0] == 0
        inicio = 0.000
      end
      val_ant = actu[9]
      val_sgt = sig[9]

      if val_ant == val_sgt
        val = val_sgt
      else
        val = val_ant
        fin = sig[0]
        intervalos_general1 << [inicio,fin,val]
        inicio = intervalos_general1.last[1]
      end

    end

    inicio = 0
    (0..cont_gen).each do |n|
      actu = @a_result[n]

      if @a_result[n + 1] != nil
        sig = @a_result[n + 1]
      else
        sig = actu
      end

      if actu[0] == 0
        inicio = 0.000
      end
      val_ant = actu[10]
      val_sgt = sig[10]

      if val_ant == val_sgt
        val = val_sgt
      else
        val = val_ant
        fin = sig[0]
        intervalos_general2 << [inicio,fin,val]
        inicio = intervalos_general2.last[1]
      end

    end

    ln_esp = intervalos_especiales.count - 1
    @te_esp = 0
    (0..ln_esp).each do |n|
      actu = intervalos_especiales[n]
      # p actu
      @te_esp = (@te_esp + ((actu[1] - actu[0]).abs * actu[2])).truncate(5)
    end

    ln_gral1 = intervalos_general1.count - 1
    @te_gral1 = 0
    (0..ln_gral1).each do |n|
      actu = intervalos_general1[n]
      # p actu
      @te_gral1 = (@te_gral1 + ((actu[1] - actu[0]).abs * actu[2])).truncate(5)
    end

    ln_gral2 = intervalos_general2.count - 1
    @te_gral2 = 0
    (0..ln_gral2).each do |n|
      actu = intervalos_general2[n]
      # p actu
      @te_gral2 = (@te_gral2 + ((actu[1] - actu[0]).abs * actu[2])).truncate(5)
    end

    # p "especiales"
    # p intervalos_especiales
    # p "general 1"
    # p intervalos_general1
    # p "general 2"
    # p intervalos_general2

    ln_esp = intervalos_especiales.count - 1
    @oc_esp = 0
    (0..ln_esp).each do |n|
      actu = intervalos_especiales[n]
      # p actu
      if actu[2] > 0
        if actu == intervalos_especiales.last and actu[1] == actu[0]
          @oc_esp = (@oc_esp + ((resta - actu[0]).abs)).truncate(5)

        else
          @oc_esp = (@oc_esp + ((actu[1] - actu[0]).abs)).truncate(5)

        end
      end
    end

    ln_gral1 = intervalos_general1.count - 1
    @oc_gral1 = 0
    (0..ln_gral1).each do |n|
      actu = intervalos_general1[n]
      # p actu
      if actu[2] > 0
        if actu == intervalos_general1.last and actu[1] == actu[0]
          @oc_gral1 = (@oc_gral1 + ((resta - actu[0]).abs)).truncate(5)

        else
          @oc_gral1 = (@oc_gral1 + ((actu[1] - actu[0]).abs)).truncate(5)

        end
      end
    end

    ln_gral2 = intervalos_general2.count - 1
    @oc_gral2 = 0
    (0..ln_gral2).each do |n|
      actu = intervalos_general2[n]
      # p actu
      if actu[2] > 0
        if actu == intervalos_general2.last and actu[1] == actu[0]
          @oc_gral2 = (@oc_gral2 + (resta - actu[1])).truncate(5)
        else
          @oc_gral2 = (@oc_gral2 + ((actu[1] - actu[0]).abs)).truncate(5)
        end
      end
    end

    # p "utilizacion especiales"
    # p @oc_esp
    # p "utilizacion caseta 1"
    # p @oc_gral1
    # p "utilizacion caseta 2"
    # p @oc_gral2

    ln_esp = intervalos_especiales.count - 1
    @ca_esp = 0
    (0..ln_esp).each do |n|
      actu = intervalos_especiales[n]
      # p actu
      @ca_esp = (@ca_esp + (((actu[1] - actu[0]).abs / @T) * actu[2])).truncate(5)
    end

    ln_gral1 = intervalos_general1.count - 1
    @ca_gral1 = 0
    (0..ln_gral1).each do |n|
      actu = intervalos_general1[n]
      # p actu
      @ca_gral1 = (@ca_gral1 + (((actu[1] - actu[0]).abs / @T) * actu[2])).truncate(5)
    end

    ln_gral2 = intervalos_general2.count - 1
    @ca_gral2 = 0
    (0..ln_gral2).each do |n|
      actu = intervalos_general2[n]
      # p actu
      @ca_gral2 = (@ca_gral2 + (((actu[1] - actu[0]).abs / @T) * actu[2])).truncate(5)
    end
    #
    # p "vehiculos especiales"
    # p @ca_esp
    # p "vehiculos caseta 1"
    # p @ca_gral1
    # p "vehiculos caseta 2"
    # p @ca_gral2

    @con = @a_aleatorios.count - 1
    @orderable = @a_aleatorios.sort
    @dis_acum = []
    @desv_abs = []
    (0..@con).each do |n|
      i = n + 1
      dist = (i / (@con + 1).to_f).truncate(5)
      @dis_acum << dist
      abso = ((@dis_acum[n] - @orderable[n]).abs).truncate(5)
      @desv_abs << abso
    end
    @est_ks = @desv_abs.max
    @vc = (1.63 / Math.sqrt(@con + 1)).truncate(5)
  end



  protected

  def form_params
    params.permit(:hini,:hfini,:med_llegada,:med_sig)
  end

  def estado_caseta(cola,tipo)
    arr = []
    if cola > 0
      estado = 1
      if tipo == 0
        aleatorio = rand.to_f.truncate(5)
        @a_aleatorios << aleatorio
        hasta = (-(1 / form_params[:med_sig].to_i.to_f) * 60 * Math.log(1 - aleatorio)).to_f.truncate(5)
      else
        aleatorio = rand.to_f.truncate(5)
        @a_aleatorios << aleatorio
        if aleatorio < 0.60000
          hasta = (3 + ( 5 * (aleatorio / 0.60000))).to_f.truncate(5)
        elsif aleatorio < 0.90000
          hasta = (8 + ( 5 * ((aleatorio - 0.60000) / 0.30000))).to_f.truncate(5)
        else
          hasta = (13 + ( 5 * ((aleatorio - 0.90000) / 1.00000))).to_f.truncate(5)
        end
      end
    else
      estado = 0
      hasta = 0
    end

    arr << [estado,hasta]

  end

  def siguiente_llegada(med_llegada)
    arr = []
    # Tiempo de Llegada siguiente vehiculo
    aleatorio = rand.to_f.truncate(5)
    @a_aleatorios << aleatorio

    tiempo = (-(1 / med_llegada.to_f) * 60 * Math.log(1 - aleatorio)).to_f.truncate(5)
    # Tipo de vehículo siguiente en llegar
    aleatorio = rand.to_f.truncate(5)
    @a_aleatorios << aleatorio
    if aleatorio < 0.33333
      tp = 0
    else
      tp = 1
    end
    tipo = tp

    arr << [tiempo,tipo]
  end



end
